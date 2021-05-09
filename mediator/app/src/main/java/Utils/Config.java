package Utils;

public interface Config {
    int MAX_TIME_WAIT_FOR_LANDING = 150000;//ms
    int MAX_TIME_WAIT_FOR_TAKEOFF = 60000;//ms
    String MAIN_CAMERA_NAME = "Zenmuse X5S";
    String RTMPUrl = "";
    float flightSpeed = 10.0f;
    long timeUploadMission = 60000;//ms
    int ThreadCount = 5;
}
