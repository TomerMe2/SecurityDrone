package components;

import Utils.MissionState;
import dji.common.model.LocationCoordinate2D;
import dji.sdk.products.Aircraft;
import dji.sdk.sdkmanager.DJISDKManager;

public class AircraftController {
    private Aircraft m_aircraft;
    private CameraController cameraController;
    private FlightControl controller;
    private static AircraftController instance;
    private BuildInMissionControl buildInMissionControl;
    private AircraftController(){initAircraft();}

    public static synchronized AircraftController getInstance(){
        if (instance == null) {
            instance = new AircraftController();
        }
        return instance;
    }

    private void initAircraft(){
        m_aircraft = (Aircraft) DJISDKManager.getInstance().getProduct();
        controller = new FlightControl(m_aircraft);
        buildInMissionControl = new BuildInMissionControl();
        cameraController = new CameraController(m_aircraft);
    }

    public void takeOff(MissionState state){
        controller.takeOff(state);
    }
    public void stopTakeOff(MissionState state){controller.cancelTakeOff(state);}
    public void goHome(MissionState state){
        controller.goHome(state);
    }
    public void setHome(MissionState state,LocationCoordinate2D loc){controller.setHome(loc,state);}
    public void stopGoHome(MissionState state){
        controller.stopGoHome(state);
    }
    public void startLanding(MissionState state){
        controller.startLanding(state);
    }
    public void stopLanding(MissionState state){
        controller.stopLanding(state);
    }
    public void goToWaypoint(float longitude, float latitude, float altitude, MissionState state){buildInMissionControl.goToWaypoint(longitude,latitude,altitude,state);}
    public void stopGoToWaypoint(MissionState state){buildInMissionControl.stopGoWaypoint(state);}
    public LocationCoordinate2D getLocation(MissionState state){return controller.getLocation(state);}
    public void takePhoto (MissionState state){cameraController.takePhoto(state);}
    public void rotateGimbal(MissionState state, float yaw,float pitch,float roll){cameraController.rotateGimbal(state,roll,yaw,pitch);}
    public void startActiveTrack(MissionState state){buildInMissionControl.startActiveTracing(state);}
    public void stopActiveTrack(MissionState state){buildInMissionControl.stopActiveTrack(state);}
}
