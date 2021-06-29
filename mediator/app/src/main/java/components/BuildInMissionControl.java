package components;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import BL.Missions.Mission;
import Utils.Config;
import Utils.Logger;
import Utils.MissionState;
import dji.common.error.DJIError;
import dji.common.mission.activetrack.ActiveTrackMission;
import dji.common.mission.activetrack.ActiveTrackMissionEvent;
import dji.common.mission.activetrack.ActiveTrackMode;
import dji.common.mission.activetrack.ActiveTrackState;
import dji.common.mission.waypoint.Waypoint;
import dji.common.mission.waypoint.WaypointMission;
import dji.common.mission.waypoint.WaypointMissionDownloadEvent;
import dji.common.mission.waypoint.WaypointMissionExecutionEvent;
import dji.common.mission.waypoint.WaypointMissionFinishedAction;
import dji.common.mission.waypoint.WaypointMissionFlightPathMode;
import dji.common.mission.waypoint.WaypointMissionHeadingMode;
import dji.common.mission.waypoint.WaypointMissionState;
import dji.common.mission.waypoint.WaypointMissionUploadEvent;
import dji.common.util.CommonCallbacks;
import dji.sdk.mission.MissionControl;
import dji.sdk.mission.activetrack.ActiveTrackMissionOperatorListener;
import dji.sdk.mission.activetrack.ActiveTrackOperator;
import dji.sdk.mission.waypoint.WaypointMissionOperator;
import dji.sdk.mission.waypoint.WaypointMissionOperatorListener;
import dji.sdk.sdkmanager.DJISDKManager;

public class BuildInMissionControl {

    private WaypointMissionOperator waypointMissionOperator;
    private WaypointMissionFinishedAction mFinishedAction = WaypointMissionFinishedAction.NO_ACTION;
    private WaypointMissionHeadingMode mHeadingMode = WaypointMissionHeadingMode.AUTO;
    private ActiveTrackOperator activeTrackOperator;

    public BuildInMissionControl(){
        MissionControl missionControl = DJISDKManager.getInstance().getMissionControl();
        waypointMissionOperator = missionControl.getWaypointMissionOperator();
        activeTrackOperator = missionControl.getActiveTrackOperator();
    }

    public void goToWaypoint(float longitude, float latitude, float altitude, MissionState state){
        WaypointMission.Builder waypointMissionBuilder = new WaypointMission.Builder().finishedAction(mFinishedAction).headingMode(mHeadingMode).autoFlightSpeed(Config.flightSpeed).maxFlightSpeed(Config.flightSpeed).flightPathMode(WaypointMissionFlightPathMode.NORMAL);
        Waypoint waypoint1 = new Waypoint(latitude,longitude,altitude);
        Waypoint waypoint2 = new Waypoint(latitude,longitude+0.00001,latitude);
        waypointMissionBuilder.addWaypoint(waypoint2);
        waypointMissionBuilder.addWaypoint(waypoint1);
        WaypointMission toExecute = waypointMissionBuilder.build();

        waypointMissionOperator.addListener(new WaypointMissionOperatorListener() {
            @Override
            public void onDownloadUpdate(@NonNull WaypointMissionDownloadEvent waypointMissionDownloadEvent) {

            }

            @Override
            public void onUploadUpdate(@NonNull WaypointMissionUploadEvent waypointMissionUploadEvent) {

            }

            @Override
            public void onExecutionUpdate(@NonNull WaypointMissionExecutionEvent waypointMissionExecutionEvent) {

            }

            @Override
            public void onExecutionStart() {

            }

            @Override
            public void onExecutionFinish(@Nullable DJIError djiError) {
                state.success();
            }
        });

        Boolean errorOccurred = false;
        DJIError loadError =  waypointMissionOperator.loadMission(toExecute);
        if(loadError != null){
            state.fail("load error " + loadError.getDescription() + " " + loadError.getClass().getName());
            Logger.sendData("load error " + loadError.getDescription() + " " + loadError.getClass().getName());
        }
        long startTime = System.currentTimeMillis();
        while (waypointMissionOperator.getCurrentState() != WaypointMissionState.READY_TO_UPLOAD) {
            if(System.currentTimeMillis() - startTime > Config.timeUploadMission){
                errorOccurred = true;
                break;
            }
        }

        if(!errorOccurred) {
            waypointMissionOperator.uploadMission(new CommonCallbacks.CompletionCallback() {
                @Override
                public void onResult(DJIError error) {
                    if (error != null) {
                        state.fail("Mission upload failed, error: " + error.getDescription() );
                        Logger.sendData("Mission upload failed, error: " + error.getDescription());
                    }
                }
            });
            startTime = System.currentTimeMillis();
            while (waypointMissionOperator.getCurrentState() != WaypointMissionState.READY_TO_EXECUTE) {
                if(System.currentTimeMillis() - startTime > Config.timeUploadMission){
                    errorOccurred = true;
                    break;
                }
            }
        }

        if(errorOccurred){
            state.fail("too much time");
        }else{
            waypointMissionOperator.startMission(new CommonCallbacks.CompletionCallback() {
                @Override
                public void onResult(DJIError djiError) {
                    if (djiError != null){
                        state.fail("Mission start failed, error: " + djiError.getDescription() );
                        Logger.sendData("Mission start failed, error: " + djiError.getDescription());
                    }
                }
            });
        }

    }

    public void stopGoWaypoint(MissionState state){
        waypointMissionOperator.stopMission(new CommonCallbacks.CompletionCallback() {
            @Override
            public void onResult(DJIError djiError) {
                if (djiError == null){
                    Logger.sendData("stop go to waypoint success");
                    state.success();
                }else {
                    Logger.sendData(djiError.getDescription());
                    state.fail("Mission stop failed, error: " + djiError.getDescription());
                }
            }
        });
    }

    public void startActiveTracing(MissionState state){
        ActiveTrackMission mission = new ActiveTrackMission(null, ActiveTrackMode.TRACE);

        activeTrackOperator.enableAutoSensing(new CommonCallbacks.CompletionCallback() {
            @Override
            public void onResult(DJIError djiError) {
                if(djiError != null){
                    Logger.sendData(djiError.getDescription());
                    state.fail(djiError.getDescription());
                }
            }
        });

        activeTrackOperator.addListener(new ActiveTrackMissionOperatorListener() {
            @Override
            public void onUpdate(ActiveTrackMissionEvent activeTrackMissionEvent) {
                Logger.sendData(activeTrackMissionEvent.getCurrentState().getName());
                if(activeTrackMissionEvent.getCurrentState().equals(ActiveTrackState.WAITING_FOR_CONFIRMATION)){
                    activeTrackOperator.acceptConfirmation(new CommonCallbacks.CompletionCallback() {
                        @Override
                        public void onResult(DJIError djiError) {
                            if(djiError!=null){
                                Logger.sendData(djiError.getDescription());
                                state.fail(djiError.getDescription());
                            }
                        }
                    });
                }
            }
        });

        activeTrackOperator.startAutoSensingMission(mission, new CommonCallbacks.CompletionCallback() {
            @Override
            public void onResult(DJIError djiError) {
                if(djiError!=null){
                    Logger.sendData(djiError.getDescription());
                    state.fail(djiError.getDescription());
                }else{
                    state.success();
                }
            }
        });
    }

    public void stopActiveTrack(MissionState state){
        ActiveTrackState trackState =  activeTrackOperator.getCurrentState();
        if(trackState == ActiveTrackState.AIRCRAFT_FOLLOWING || trackState == ActiveTrackState.WAITING_FOR_CONFIRMATION || trackState == ActiveTrackState.CANNOT_CONFIRM || trackState == ActiveTrackState.FINDING_TRACKED_TARGET) {
            activeTrackOperator.stopTracking(new CommonCallbacks.CompletionCallback() {
                @Override
                public void onResult(DJIError djiError) {
                    if(djiError!=null){
                        Logger.sendData(djiError.getDescription());
                        state.fail(djiError.getDescription());
                    }else{
                        state.success();
                    }
                }
            });
        }
    }
}
