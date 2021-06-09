package communication;

import BL.Missions.Mission;

public interface SocketManager {
    //this class should be singleton

    //init connection with the server
    void init();

    //decode the mission sent by the server and add it to the TaskManager
    Mission decode();
}
