package BL.Missions;


import Utils.Logger;
import Utils.MissionState;
import Utils.State;
import components.AircraftController;

public class TakePhoto extends Mission {

    private Boolean take = true;


    public TakePhoto(AircraftController controller) {
        super(controller);
    }

    @Override
    public void run() {
        while (take) {
            MissionState state = new MissionState();
            controller.takePhoto(state);
            while (state.currentState() == State.Pending) {
            }
            running = false;
            if (state.currentState() == State.Fail) {
                failed = true;
            }
            try{
                wait(30000);
            }catch (Exception e){

            }
        }
    }

    @Override
    public void stop() {
        take = false;
    }
}
