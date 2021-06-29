package BL.Missions;


import Utils.Config;
import Utils.Logger;
import Utils.MissionState;
import Utils.State;
import components.AircraftController;

import static java.lang.Thread.sleep;

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
            try {
                sleep(Config.time_between_photos);
            } catch (Exception e) {
                Logger.sendData(e.getMessage());
            }
        }
    }

    @Override
    public void stop() {
        take = false;
        Thread t = new Thread(new Runnable() {
            @Override
            public void run() {
                Logger.sendData("stop taking photos");
            }
        });
        t.start();
    }
}
