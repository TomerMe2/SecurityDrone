package communication;

import BL.Missions.Mission;

public interface SocketManager {
    //should be singleton
    void init();
    //u can change it
    //it should call business layer but u can leave the call to me
    Mission decode(Byte[]buffer);
    void sendServer(String msg);
}
