package BL.Missions;

import components.AircraftController;

public abstract class Mission implements Runnable {
    AircraftController controller;
    Boolean running = true;
    Boolean failed = false;
    Boolean stopped = false;
    String error = "";
    public Mission(AircraftController controller){
    this.controller=controller;
    }
    public abstract void run();
    public abstract void stop();

    public boolean isRunning(){
        synchronized (running) {
            return running;
        }
    }

    public Boolean wasError(){
        return failed;
    }

    public String getError(){
        return error;
    }
}
