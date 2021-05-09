package BL.Missions;

import Utils.MissionState;
import Utils.State;
import components.AircraftController;

public class GoToWaypoint extends Mission {
    private float longitude;
    private float latitude;
    private float altitude;

    public GoToWaypoint(AircraftController controller,float longitude,float latitude,float altitude) {
        super(controller);
        this.longitude=longitude;
        this.altitude = altitude;
        this.latitude = latitude;
    }

    @Override
    public void run() {
        MissionState state = new MissionState();
        controller.goToWaypoint(longitude,latitude,altitude,state);
        while(state.currentState() == State.Pending){}
        running = false;
        if(state.currentState()== State.Fail){
            failed = true;
        }
    }

    @Override
    public void stop() {
        MissionState state = new MissionState();
        controller.stopGoToWaypoint(state);
        while(state.currentState() == State.Pending){}
        running = false;
        if(state.currentState() == State.Success){
            stopped = true;
        }else if(state.currentState() == State.Fail){
            failed = true;
        }
    }
}
