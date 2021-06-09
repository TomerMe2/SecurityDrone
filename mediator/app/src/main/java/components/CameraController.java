package components;
import android.graphics.Bitmap;
import android.os.Handler;

import java.io.File;
import java.io.FileOutputStream;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import Utils.Logger;
import Utils.MissionState;
import dji.common.camera.SettingsDefinitions;
import dji.common.error.DJIError;
import dji.common.util.CommonCallbacks;
import dji.sdk.camera.Camera;
import dji.sdk.media.MediaFile;
import dji.sdk.media.MediaManager;
import dji.sdk.products.Aircraft;

public class CameraController {
    private Camera camera;
    private List<MediaFile> mediaFileList;
    private MediaManager mMediaManager;

    public CameraController(Aircraft aircraft){
        camera = aircraft.getCamera();
        mMediaManager = camera.getMediaManager();
    }


    private void download() {

        mMediaManager.refreshFileListOfStorageLocation(SettingsDefinitions.StorageLocation.SDCARD, new CommonCallbacks.CompletionCallback() {

            @Override
            public void onResult(DJIError djiError) {
                if (null == djiError) {

                    mediaFileList = mMediaManager.getSDCardFileListSnapshot();
                    Collections.sort(mediaFileList, new Comparator<MediaFile>() {
                        @Override
                        public int compare(MediaFile lhs, MediaFile rhs) {
                            if (lhs.getTimeCreated() < rhs.getTimeCreated()) {
                                return 1;
                            } else if (lhs.getTimeCreated() > rhs.getTimeCreated()) {
                                return -1;
                            }
                            return 0;
                        }
                    });

                    MediaFile file = mediaFileList.get(0);
                    file.fetchPreview(new CommonCallbacks.CompletionCallback() {
                        @Override
                        public void onResult(DJIError djiError) {
                            if (djiError == null) {
                                Bitmap bitmap = file.getPreview();
                                File toDownload = new File("/mnt/internal_sd/DJI/com.dji.industry.pilot/security", file.getFileName() + ".jpg");
                                try {
                                    FileOutputStream out = new FileOutputStream(toDownload);
                                    bitmap.compress(Bitmap.CompressFormat.JPEG, 90, out);
                                    out.flush();
                                    out.close();
                                } catch (Exception e) {
                                }
                            }
                        }
                    });
                }
            }
        });
    }

    public void takePhoto(MissionState state){
        SettingsDefinitions.ShootPhotoMode photoMode = SettingsDefinitions.ShootPhotoMode.SINGLE; // Set the camera capture mode as Single mode
        camera.setShootPhotoMode(photoMode, new CommonCallbacks.CompletionCallback(){
            @Override
            public void onResult(DJIError djiError) {
                if (null == djiError) {
                    camera.startShootPhoto(new CommonCallbacks.CompletionCallback() {
                        @Override
                        public void onResult(DJIError djiError) {
                            if (djiError == null) {
                                state.success();
                                download();
                            } else {
                                state.fail(djiError.getDescription());
                            }
                        }
                    });
                }
            }
        });
    }

}
