package BL.Missions;

import Utils.MissionState;
import Utils.State;
import components.AircraftController;
import dji.common.model.LocationCoordinate2D;

public class SetHomeLocation extends Mission {

    private LocationCoordinate2D loc;

    public SetHomeLocation(AircraftController controller,LocationCoordinate2D loc){
        super(controller);
        this.loc = loc;
    }

    @Override
    public void run() {
        MissionState state = new MissionState();
        controller.setHome(state, loc);
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
