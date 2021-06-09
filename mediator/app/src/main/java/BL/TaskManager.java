package BL;

import android.util.Log;

import java.util.ArrayList;
import java.util.List;

import BL.Missions.GoHome;
import BL.Missions.GoToWaypoint;
import BL.Missions.Land;
import BL.Missions.Mission;
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

    public static synchronized TaskManager getInstance(){
        if (instance == null){
            instance = new TaskManager();
        }
        return instance;
    }

    public void addTakeOffMission(){
        AircraftController controller = AircraftController.getInstance();
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
        AircraftController controller = AircraftController.getInstance();
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
        AircraftController controller = AircraftController.getInstance();
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
        AircraftController controller = AircraftController.getInstance();
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
        AircraftController controller = AircraftController.getInstance();
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

            AircraftController controller = AircraftController.getInstance();

            cameraMission = new TakePhoto(controller);
            Thread t = new Thread(new Runnable() {
                @Override
                public void run() {
                    cameraMission.run();
                }
            });
            t.start();
        }catch (Exception e){
            Logger.sendData(e.getMessage());
        }
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
