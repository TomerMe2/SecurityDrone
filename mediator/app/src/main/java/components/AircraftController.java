package components;

import dji.common.model.LocationCoordinate2D;
import dji.sdk.products.Aircraft;
import dji.sdk.sdkmanager.DJISDKManager;

public class AircraftController {
    private Aircraft m_aircraft;
    private FlightControl controller;
    private static AircraftController instance;
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
    }

    public synchronized void takeOff(){
        controller.takeOff();
    }
    public synchronized void goHome(){
        controller.goHome();
    }
    public synchronized void stopGoHome(){
        controller.stopGoHome();
    }
    public synchronized void startLanding(){
        controller.startLanding();
    }
    public synchronized void stopLanding(){
        controller.stopLanding();
    }
    public synchronized LocationCoordinate2D getLocation(){return controller.getLocation();}
}
