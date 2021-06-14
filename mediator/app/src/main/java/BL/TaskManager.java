package BL;

import BL.Missions.GoHome;
import BL.Missions.GoToWaypoint;
import BL.Missions.Land;
import BL.Missions.Mission;
import BL.Missions.MoveGimbal;
import BL.Missions.SetHomeLocation;
import BL.Missions.TakeOff;
import BL.Missions.TakePhoto;
import Utils.Logger;
import components.AircraftController;
import dji.common.model.LocationCoordinate2D;


public class TaskManager {
    private Mission currentMission;
    private Mission cameraMission;
    private static TaskManager instance=null;
    private AircraftController controller;

    public static synchronized TaskManager getInstance(){
        if (instance == null){
            instance = new TaskManager();
        }
        return instance;
    }

    public TaskManager(){
        controller = AircraftController.getInstance();
    }

    public void addTakeOffMission(){
        Mission m = new TakeOff(controller);
        Thread t = new Thread(new Runnable() {
            @Override
            public void run() {

                currentMission = m;
                currentMission.run();
            }
        });
        t.start();
    }

    public void addLandMission(){
        Mission m = new Land(controller);
        Thread t = new Thread(new Runnable() {
            @Override
            public void run() {

                currentMission = m;
                currentMission.run();
            }
        });
        t.start();
    }

    public void addGoHomeMission(){
        Mission m = new GoHome(controller);
        Thread t = new Thread(new Runnable() {
            @Override
            public void run() {

                currentMission = m;
                currentMission.run();
            }
        });
        t.start();
    }

    public void addSetHomeMission(LocationCoordinate2D loc){
        Mission m = new SetHomeLocation(controller,loc);
        Thread t = new Thread(new Runnable() {
            @Override
            public void run() {

                currentMission = m;
                currentMission.run();
            }
        });
        t.start();
    }

    public void addGoToWaypointMission(float longitude,float latitude,float altitude){
        Mission m = new GoToWaypoint(controller, longitude, latitude, altitude);
        Thread t = new Thread(new Runnable() {
            @Override
            public void run() {
                currentMission = m;
                currentMission.run();
            }
        });
        t.start();
    }

    public void takePhotos(){
        try {


            cameraMission = new TakePhoto(controller);
            Thread t = new Thread(new Runnable() {
                @Override
                public void run() {
                    cameraMission.run();
                }
            });
            t.start();
        }catch (Exception e){
            Thread n = new Thread(new Runnable() {
                @Override
                public void run() {
                    Logger.sendData(e.getMessage());
                }
            });
           n.start();
        }
    }

    public void moveGimbal(float yaw,float roll,float pitch){
        Thread n = new Thread(new Runnable() {
            @Override
            public void run() {
                Mission rotate = new MoveGimbal(controller,roll,pitch,yaw);
                rotate.run();
            }
        });
        n.start();
    }

    public void stopTakingPhotos(){
        Thread s = new Thread(new Runnable() {
            @Override
            public void run() {
                cameraMission.stop();
            }
        });
        s.start();
    }

    public void stopAllMissions(){

        if(currentMission.isRunning()){
            Thread t = new Thread(new Runnable() {
                @Override
                public void run() {
                    currentMission.stop();
                }
            });
            t.start();
        }

    }

}
