package BL.Missions;

import Utils.MissionState;
import Utils.State;
import components.AircraftController;

public class TakeOff extends Mission {

    public TakeOff(AircraftController controller) {
        super(controller);
    }

    @Override
    public void run() {
        MissionState state = new MissionState();
        controller.takeOff(state);
        while(state.currentState() == State.Pending){}
        running = false;
        if(state.currentState()== State.Fail){
            failed = true;
        }
    }

    @Override
    public void stop() {
        MissionState state = new MissionState();
        controller.stopTakeOff(state);
        while(state.currentState() == State.Pending){}
        running = false;
        if(state.currentState() == State.Success){
            stopped = true;
        }else if(state.currentState() == State.Fail){
            failed = true;
        }
    }
}
