package BL.Missions;

import Utils.Config;
import Utils.Logger;
import Utils.MissionState;
import Utils.State;
import components.AircraftController;

import static java.lang.Thread.sleep;

public class ActiveTrack extends Mission {


    public ActiveTrack(AircraftController controller) {
        super(controller);
    }

    @Override
    public void run() {
        MissionState state = new MissionState();
        controller.startActiveTrack(state);
    }

    @Override
    public void stop() {
        MissionState state = new MissionState();
        controller.stopActiveTrack(state);
    }
}
