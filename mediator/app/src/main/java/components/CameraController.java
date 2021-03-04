package components;
import androidx.annotation.NonNull;

import java.util.List;

import Utils.Config;
import dji.common.camera.SettingsDefinitions.CameraMode;
import dji.common.error.DJIError;
import dji.common.util.CommonCallbacks;
import dji.sdk.camera.Camera;
import dji.sdk.sdkmanager.DJISDKManager;
import dji.sdk.sdkmanager.LiveStreamManager;

public class CameraController {
    private List<Camera> cameras;
    private Camera mainCam;
    private LiveStreamManager liveStreamManager;

    public CameraController(List<Camera> cameras){
        this.cameras = cameras;
        mainCam = getCamera();
        DJISDKManager manager = DJISDKManager.getInstance();
        liveStreamManager = manager.getLiveStreamManager();
        initCamera();
    }


    private Camera getCamera() {

        for (Camera c : cameras) {
            if (c.getDisplayName().equals(Config.MAIN_CAMERA_NAME)) {
                return c;
            }
        }

        return null;
    }

    private void initCamera(){
        mainCam.setMode(CameraMode.RECORD_VIDEO, new CommonCallbacks.CompletionCallback() {
            @Override
            public void onResult(DJIError djiError) {
                if(djiError == null){
                    //TODO add of true
                }else {
                    //TODO add if false
                }
            }
        });
        liveStreamManager.setLiveUrl(Config.RTMPUrl);
    }

    public void startStream(){
        liveStreamManager.startStream();
    }

    public void stopStream(){
        liveStreamManager.stopStream();
    }
}
