package components;
import java.util.List;

import Utils.Config;
import dji.common.camera.SettingsDefinitions.CameraMode;
import dji.common.error.DJIError;
import dji.common.util.CommonCallbacks;
import dji.sdk.camera.Camera;

public class CameraController {
    private List<Camera> cameras;
    private Camera main;

    public CameraController(List<Camera>camers){
        this.cameras = camers;
        main = getCamera();
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
        main.setMode(CameraMode.SHOOT_PHOTO, new CommonCallbacks.CompletionCallback() {
            @Override
            public void onResult(DJIError djiError) {
                if(djiError == null){
                    try {
                        Thread.sleep(2000);
                    } catch (InterruptedException e) {
                    }
                    //TODO add of true
                }else {
                    //TODO add if false
                }
            }
        });
    }
}
