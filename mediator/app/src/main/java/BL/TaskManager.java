package BL;

import java.util.ArrayList;
import java.util.List;
import BL.Missions.Mission;


public class TaskManager {
    private List<Mission> currentMissions;
    private static TaskManager instance=null;

    public static synchronized TaskManager getInstance(){
        if (instance == null){
            instance = new TaskManager();
        }
        return instance;
    }

    private TaskManager(){
        currentMissions = new ArrayList<>();
        Thread t = new Thread(new Runnable() {
            @Override
            public void run() {
                while(true){
                    synchronized (currentMissions){
                        for (Mission m : currentMissions){
                            if(!m.isRunning()){
                                currentMissions.remove(m);
                            }
                        }
                        try {
                            wait(1000);
                        } catch (InterruptedException e) {
                        }
                    }
                }
            }
        });
        t.start();
    }

    public void addMission(Mission m){
        Thread t = new Thread(new Runnable() {
            @Override
            public void run() {
                m.run();
                synchronized (currentMissions) {
                    currentMissions.add(m);
                }
            }
        });
        t.start();
    }

    public void stopAllMissions(){
        synchronized (currentMissions){
            for(Mission m:currentMissions){
                if(m.isRunning()){
                    m.stop();
                }
            }
        }
    }
}
