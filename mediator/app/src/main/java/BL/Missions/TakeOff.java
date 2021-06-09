package BL.Missions;

import Utils.Logger;
import Utils.MissionState;
import Utils.State;
import components.AircraftController;

public class TakeOff extends Mission {

    public TakeOff(AircraftController controller) {
        super(controller);
    }

    @Override
    public void run() {
        Logger.sendData("take of is starting");
        MissionState state = new MissionState();
        controller.takeOff(state);
        while(state.currentState() == State.Pending){}
        running = false;
        if(state.currentState()== State.Fail){
            failed = true;
        }
        Logger.sendData(isRunning() ? "take off still running" : "take off is not running anymore ");
    }

    @Override
    public void stop() {
        Logger.sendData("take of is stopping");
        MissionState state = new MissionState();
        controller.stopTakeOff(state);
        while(state.currentState() == State.Pending){}
        running = false;
        if(state.currentState() == State.Success){
            stopped = true;
        }else if(state.currentState() == State.Fail){
            failed = true;
        }
        Logger.sendData(isRunning() ? "take off still running" : "take off is not running anymore ");
    }
}
