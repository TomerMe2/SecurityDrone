package BL.Missions;

import Utils.Logger;
import Utils.MissionState;
import Utils.State;
import components.AircraftController;

public class MoveGimbal extends Mission {

    float roll;
    float pitch;
    float yaw;

    public MoveGimbal(AircraftController controller , float roll,float pitch,float yaw) {
        super(controller);
        this.pitch = pitch;
        this.yaw = yaw;
        this.roll = roll;
    }

    @Override
    public void run() {
        MissionState state = new MissionState();
        controller.rotateGimbal(state,yaw,pitch,roll);
        while(state.currentState() == State.Pending){}
        running = false;
        if(state.currentState()== State.Fail){
            failed = true;
        }
    }

    @Override
    public void stop() {

    }
}
