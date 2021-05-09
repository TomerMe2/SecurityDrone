package BL.Missions;

import Utils.MissionState;
import Utils.State;
import components.AircraftController;

public class GoHome extends Mission {

    public GoHome(AircraftController controller) {
        super(controller);
    }

    @Override
    public void run() {
        MissionState state = new MissionState();
        controller.goHome(state);
        while(state.currentState() == State.Pending){}
        running = false;
        if(state.currentState()== State.Fail){
            failed = true;
        }
    }

    @Override
    public void stop() {
        MissionState state = new MissionState();
        controller.stopGoHome(state);
        while(state.currentState() == State.Pending){}
        running = false;
        if(state.currentState() == State.Success){
            stopped = true;
        }else if(state.currentState() == State.Fail){
            failed = true;
        }
    }
}
