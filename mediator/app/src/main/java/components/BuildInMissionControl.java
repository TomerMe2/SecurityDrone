package components;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import Utils.Config;
import Utils.Logger;
import Utils.MissionState;
import dji.common.error.DJIError;
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
import dji.sdk.mission.waypoint.WaypointMissionOperator;
import dji.sdk.mission.waypoint.WaypointMissionOperatorListener;
import dji.sdk.sdkmanager.DJISDKManager;

public class BuildInMissionControl {

    private WaypointMissionOperator operator;
    private WaypointMissionFinishedAction mFinishedAction = WaypointMissionFinishedAction.NO_ACTION;
    private WaypointMissionHeadingMode mHeadingMode = WaypointMissionHeadingMode.AUTO;

    public BuildInMissionControl(){
        MissionControl missionControl = DJISDKManager.getInstance().getMissionControl();
        operator = missionControl.getWaypointMissionOperator();
    }

    public void goToWaypoint(float longitude, float latitude, float altitude, MissionState state){
        WaypointMission.Builder waypointMissionBuilder = new WaypointMission.Builder().finishedAction(mFinishedAction).headingMode(mHeadingMode).autoFlightSpeed(Config.flightSpeed).maxFlightSpeed(Config.flightSpeed).flightPathMode(WaypointMissionFlightPathMode.NORMAL);
        Waypoint waypoint1 = new Waypoint(31.259100f,34.831906f,7.0f);
        Waypoint waypoint2 = new Waypoint(31.259163f,34.831628f,7.0f);
        waypointMissionBuilder.addWaypoint(waypoint2);
        waypointMissionBuilder.addWaypoint(waypoint1);
        WaypointMission toExecute = waypointMissionBuilder.build();

        operator.addListener(new WaypointMissionOperatorListener() {
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
        DJIError loadError =  operator.loadMission(toExecute);
        if(loadError != null){
            state.fail("load error " + loadError.getDescription() + " " + loadError.getClass().getName());
        }
        long startTime = System.currentTimeMillis();
        while (operator.getCurrentState() != WaypointMissionState.READY_TO_UPLOAD) {
            if(System.currentTimeMillis() - startTime > Config.timeUploadMission){
                errorOccurred = true;
                break;
            }
        }

        if(!errorOccurred) {
            operator.uploadMission(new CommonCallbacks.CompletionCallback() {
                @Override
                public void onResult(DJIError error) {
                    if (error != null) {
                        state.fail("Mission upload failed, error: " + error.getDescription() );
                    }
                }
            });
            startTime = System.currentTimeMillis();
            while (operator.getCurrentState() != WaypointMissionState.READY_TO_EXECUTE) {
                if(System.currentTimeMillis() - startTime > Config.timeUploadMission){
                    errorOccurred = true;
                    break;
                }
            }
        }

        if(errorOccurred){
            state.fail("too much time");
        }else{
            operator.startMission(new CommonCallbacks.CompletionCallback() {
                @Override
                public void onResult(DJIError djiError) {
                    if (djiError != null){
                        state.fail("Mission start failed, error: " + djiError.getDescription() );
                    }
                }
            });
        }

    }

    public void stopGoWaypoint(MissionState state){
        operator.stopMission(new CommonCallbacks.CompletionCallback() {
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
}
