package components;

import Utils.Config;
import Utils.MissionState;
import dji.common.error.DJIError;
import dji.common.mission.waypoint.Waypoint;
import dji.common.mission.waypoint.WaypointMission;
import dji.common.mission.waypoint.WaypointMissionFinishedAction;
import dji.common.mission.waypoint.WaypointMissionFlightPathMode;
import dji.common.mission.waypoint.WaypointMissionHeadingMode;
import dji.common.mission.waypoint.WaypointMissionState;
import dji.common.util.CommonCallbacks;
import dji.sdk.mission.MissionControl;
import dji.sdk.mission.waypoint.WaypointMissionOperator;
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
        Waypoint waypoint = new Waypoint(latitude,longitude,altitude);
        waypointMissionBuilder.addWaypoint(waypoint);
        WaypointMission toExecute = waypointMissionBuilder.build();

        Boolean errorOccurred = false;
        operator.loadMission(toExecute);
        long startTime = System.currentTimeMillis();
        while (operator.getCurrentState() != WaypointMissionState.READY_TO_UPLOAD) {
            if(System.currentTimeMillis() - startTime > Config.timeUploadMission){
                errorOccurred = true;
                break;
            }
        }

        if(!errorOccurred) {
            operator.uploadMission(null);
            startTime = System.currentTimeMillis();
            while (operator.getCurrentState() != WaypointMissionState.READY_TO_EXECUTE) {
                if(System.currentTimeMillis() - startTime > Config.timeUploadMission){
                    errorOccurred = true;
                    break;
                }
            }
        }

        if(errorOccurred){
            state.fail();
        }else{
            operator.startMission(new CommonCallbacks.CompletionCallback() {
                @Override
                public void onResult(DJIError djiError) {
                    if (djiError == null){
                        state.success();
                    }else {
                        state.fail();
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
                    state.success();
                }else {
                    state.fail();
                }
            }
        });
    }
}
