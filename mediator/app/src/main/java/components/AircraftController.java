package components;

import Utils.MissionState;
import dji.common.model.LocationCoordinate2D;
import dji.sdk.products.Aircraft;
import dji.sdk.sdkmanager.DJISDKManager;

public class AircraftController {
    private Aircraft m_aircraft;
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
    }

    public synchronized void takeOff(MissionState state){
        controller.takeOff(state);
    }
    public synchronized void stopTakeOff(MissionState state){controller.cancelTakeOff(state);}
    public synchronized void goHome(MissionState state){
        controller.goHome(state);
    }
    public synchronized void stopGoHome(MissionState state){
        controller.stopGoHome(state);
    }
    public synchronized void startLanding(MissionState state){
        controller.startLanding(state);
    }
    public synchronized void stopLanding(MissionState state){
        controller.stopLanding(state);
    }
    public synchronized void goToWaypoint(float longitude, float latitude, float altitude, MissionState state){buildInMissionControl.goToWaypoint(longitude,latitude,altitude,state);}
    public synchronized void stopGoToWaypoint(MissionState state){buildInMissionControl.stopGoWaypoint(state);}
    public synchronized LocationCoordinate2D getLocation(MissionState state){return controller.getLocation(state);}
}
