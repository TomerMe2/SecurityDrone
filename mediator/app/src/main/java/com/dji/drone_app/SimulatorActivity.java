package com.dji.drone_app;

import android.Manifest;
import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.ToggleButton;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import java.io.File;
import java.io.FileOutputStream;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.concurrent.atomic.AtomicBoolean;

import BL.TaskManager;
import Utils.Config;
import Utils.Logger;
import dji.common.camera.SettingsDefinitions;
import dji.common.error.DJIError;
import dji.common.error.DJISDKError;
import dji.common.mission.waypoint.Waypoint;
import dji.common.mission.waypoint.WaypointMission;
import dji.common.mission.waypoint.WaypointMissionDownloadEvent;
import dji.common.mission.waypoint.WaypointMissionExecutionEvent;
import dji.common.mission.waypoint.WaypointMissionFinishedAction;
import dji.common.mission.waypoint.WaypointMissionFlightPathMode;
import dji.common.mission.waypoint.WaypointMissionHeadingMode;
import dji.common.mission.waypoint.WaypointMissionState;
import dji.common.mission.waypoint.WaypointMissionUploadEvent;
import dji.common.model.LocationCoordinate2D;
import dji.common.util.CommonCallbacks;
import dji.sdk.base.BaseComponent;
import dji.sdk.base.BaseProduct;
import dji.sdk.camera.Camera;
import dji.sdk.media.MediaFile;
import dji.sdk.media.MediaManager;
import dji.sdk.mission.MissionControl;
import dji.sdk.mission.waypoint.WaypointMissionOperator;
import dji.sdk.mission.waypoint.WaypointMissionOperatorListener;
import dji.sdk.products.Aircraft;
import dji.sdk.sdkmanager.DJISDKInitEvent;
import dji.sdk.sdkmanager.DJISDKManager;
import simulator.DJISimulatorApplication;


public class SimulatorActivity  extends Activity implements View.OnClickListener {


    private Handler mHandler;
    private static final String TAG = SimulatorActivity.class.getName();
    private static final int REQUEST_PERMISSION_CODE = 12345;
    protected TextView mConnectStatusTextView;
    private Button mBtnTakePhoto;
    private Button mBtnStopTakePhoto;
    private Button mBtnTakeOff;
    private Button mBtnLand;
    private Button mBtnInit;
    private Button mBtnWaypoint;
    private Button mBtnstop;
    private Button exit;
    private Button mBtnGoHome;
    private Button mRotate;
    private AtomicBoolean isRegistrationInProgress = new AtomicBoolean(false);
    public static final String FLAG_CONNECTION_CHANGE = "dji_sdk_connection_change";
    private List<String> missingPermission = new ArrayList<>();
    private static final String[] REQUIRED_PERMISSION_LIST = new String[]{
            Manifest.permission.VIBRATE,
            Manifest.permission.INTERNET,
            Manifest.permission.ACCESS_WIFI_STATE,
            Manifest.permission.WAKE_LOCK,
            Manifest.permission.ACCESS_COARSE_LOCATION,
            Manifest.permission.ACCESS_NETWORK_STATE,
            Manifest.permission.ACCESS_FINE_LOCATION,
            Manifest.permission.CHANGE_WIFI_STATE,
            Manifest.permission.WRITE_EXTERNAL_STORAGE,
            Manifest.permission.BLUETOOTH,
            Manifest.permission.BLUETOOTH_ADMIN,
            Manifest.permission.READ_EXTERNAL_STORAGE,
            Manifest.permission.READ_PHONE_STATE,
            Manifest.permission.WRITE_EXTERNAL_STORAGE,
    };

    private TaskManager manager;
    private List<MediaFile> mediaFileList = null;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        checkAndRequestPermissions();
        mHandler = new Handler(Looper.getMainLooper());

        setContentView(R.layout.activity_main);
        initUI();
    }
    /**
     * Checks if there is any missing permissions, and
     * requests runtime permission if needed.
     */
    private void checkAndRequestPermissions() {
        // Check for permissions
        for (String eachPermission : REQUIRED_PERMISSION_LIST) {
            if (ContextCompat.checkSelfPermission(this, eachPermission) != PackageManager.PERMISSION_GRANTED) {
                missingPermission.add(eachPermission);
            }
        }
        // Request for missing permissions
        if (missingPermission.isEmpty()) {
            startSDKRegistration();
        } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            showToast("Need to grant the permissions!");
            ActivityCompat.requestPermissions(this,
                    missingPermission.toArray(new String[missingPermission.size()]),
                    REQUEST_PERMISSION_CODE);
        }

    }


    @Override
    public void onResume() {
        Log.e(TAG, "onResume");
        super.onResume();
    }

    private void updateTitleBar() {
        if(mConnectStatusTextView == null) return;
        boolean ret = false;
        BaseProduct product = DJISimulatorApplication.getProductInstance();
        if (product != null) {

            if (product.isConnected()) {
                //The product is connected
                mConnectStatusTextView.setText(DJISimulatorApplication.getProductInstance().getModel() + " Connected");

                ret = true;
            } else {
                if (product instanceof Aircraft) {
                    Aircraft aircraft = (Aircraft) product;
                    if (aircraft.getRemoteController() != null && aircraft.getRemoteController().isConnected()) {
                        // The product is not connected, but the remote controller is connected
                        mConnectStatusTextView.setText("only RC Connected");
                        showToast("only RC Connected\"");
                        ret = true;
                    }
                }
            }
        }

        if(!ret) {
            // The product or the remote controller are not connected.
            mConnectStatusTextView.setText("Disconnected");
        }
    }

    /**
     * Result of runtime permission request
     */
    @Override
    public void onRequestPermissionsResult(int requestCode,
                                           @NonNull String[] permissions,
                                           @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        // Check for granted permission and remove from missing list
        if (requestCode == REQUEST_PERMISSION_CODE) {
            for (int i = grantResults.length - 1; i >= 0; i--) {
                if (grantResults[i] == PackageManager.PERMISSION_GRANTED) {
                    missingPermission.remove(permissions[i]);
                }
            }
        }
        // If there is enough permission, we will start the registration
        if (missingPermission.isEmpty()) {
            startSDKRegistration();
        } else {
            showToast("Missing permissions!!!");
        }
    }

    @Override
    public void onPause() {
        Log.e(TAG, "onPause");
        super.onPause();
    }

    @Override
    public void onStop() {
        Log.e(TAG, "onStop");
        super.onStop();
    }

    public void onReturn(View view){
        Log.e(TAG, "onReturn");
        this.finish();
    }

    @Override
    protected void onDestroy() {
        Log.e(TAG, "onDestroy");
        super.onDestroy();
    }

    private void initUI() {

        mBtnTakePhoto = (Button) findViewById(R.id.btn_take_photo);
        mBtnStopTakePhoto = (Button) findViewById(R.id.btn_stop_photo);
        mBtnTakeOff = (Button) findViewById(R.id.btn_take_off);
        mBtnLand = (Button) findViewById(R.id.btn_land);
        mConnectStatusTextView = (TextView) findViewById(R.id.ConnectStatusTextView);
        mBtnInit = (Button)findViewById(R.id.btn_init);
        mBtnWaypoint = (Button)findViewById(R.id.btn_go_to_waypont);
        mBtnstop = (Button)findViewById(R.id.btn_stop_mission);
        mBtnGoHome = (Button)findViewById(R.id.btn_home);
        exit = (Button)findViewById(R.id.exit);
        mRotate = (Button)findViewById(R.id.btn_rotate);

        mBtnTakePhoto.setOnClickListener(this);
        mBtnStopTakePhoto.setOnClickListener(this);
        mBtnTakeOff.setOnClickListener(this);
        mBtnLand.setOnClickListener(this);
        mBtnInit.setOnClickListener(this);
        mBtnWaypoint.setOnClickListener(this);
        mBtnstop.setOnClickListener(this);
        mBtnGoHome.setOnClickListener(this);
        exit.setOnClickListener(this);
        mRotate.setOnClickListener(this);
    }

    private void goByWaypoint(){
        showToast("waypoint mission start");
        MissionControl missionControl = DJISDKManager.getInstance().getMissionControl();
        WaypointMissionOperator operator = missionControl.getWaypointMissionOperator();
        float latitude = 22.5430f;
        float longitude = 113.9590f;
        float altitude = 12.0f;
        float mSpeed = 10.0f;
        WaypointMissionFinishedAction mFinishedAction = WaypointMissionFinishedAction.NO_ACTION;
        WaypointMissionHeadingMode mHeadingMode = WaypointMissionHeadingMode.AUTO;
        WaypointMission.Builder waypointMissionBuilder = new WaypointMission.Builder()
                .finishedAction(mFinishedAction)
                .headingMode(mHeadingMode)
                .autoFlightSpeed(mSpeed)
                .maxFlightSpeed(mSpeed)
                .flightPathMode(WaypointMissionFlightPathMode.NORMAL);
        Waypoint waypoint1 = new Waypoint(latitude,longitude,altitude);
        Waypoint waypoint2 = new Waypoint(latitude+0.0001,longitude,altitude);
        waypointMissionBuilder.addWaypoint(waypoint1);
        waypointMissionBuilder.addWaypoint(waypoint2);
        WaypointMission toExecute = waypointMissionBuilder.build();
        operator.addListener(new WaypointMissionOperatorListener() {
            @Override
            public void onDownloadUpdate(@NonNull WaypointMissionDownloadEvent waypointMissionDownloadEvent) {

            }

            @Override
            public void onUploadUpdate(@NonNull WaypointMissionUploadEvent waypointMissionUploadEvent) {

            }

            @Override
            public void onExecutionUpdate(@NonNull WaypointMissionExecutionEvent waypointMissionExecutionEvent) {

            }

            @Override
            public void onExecutionStart() {

            }

            @Override
            public void onExecutionFinish(@Nullable DJIError djiError) {
                showToast("go waypoint finished");
            }
        });
        DJIError loadError =  operator.loadMission(toExecute);
        if(loadError != null){
            showToast("load error " + loadError.getDescription() + " " + loadError.getClass().getName());
        }

        boolean errorOccurred = false;
        long startTime = System.currentTimeMillis();
        while (operator.getCurrentState() != WaypointMissionState.READY_TO_UPLOAD) {
            if(System.currentTimeMillis() - startTime > Config.timeUploadMission){
                errorOccurred = true;
                break;
            }
        }

        if(!errorOccurred) {
            operator.uploadMission(new CommonCallbacks.CompletionCallback() {
                @Override
                public void onResult(DJIError error) {
                    if (error == null) {
                        showToast("Mission upload successfully!");
                    } else {
                        showToast("Mission upload failed, error: " + error.getDescription() + " retrying...");
                    }
                }
            });
            startTime = System.currentTimeMillis();
            while (operator.getCurrentState() != WaypointMissionState.READY_TO_EXECUTE) {
                if(System.currentTimeMillis() - startTime > Config.timeUploadMission){
                    errorOccurred = true;
                    break;
                }
            }
        }
        if(!errorOccurred) {
            operator.startMission(new CommonCallbacks.CompletionCallback() {
                @Override
                public void onResult(DJIError djiError) {
                    showToast("Execution finished: " + (djiError == null ? "Success!" : djiError.getDescription()));
                }
            });
        }else{
            showToast("error occurred");
        }
    }



    private void download(){
        BaseProduct mProduct = DJISDKManager.getInstance().getProduct();
        Camera camera = mProduct.getCamera();
        MediaManager mMediaManager = camera.getMediaManager();

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
                            if(djiError == null){
                                Bitmap bitmap = file.getPreview();
                                File toDownload = new File("/mnt/internal_sd/DJI/com.dji.industry.pilot/security", file.getFileName() + ".jpg") ;
                                try {
                                    FileOutputStream out = new FileOutputStream(toDownload);
                                    bitmap.compress(Bitmap.CompressFormat.JPEG, 90, out);
                                    out.flush();
                                    out.close();
                                    showToast("success");
                                } catch (Exception e) {
                                }
                            }
                        }
                    });
                }
            }
        });
    }

    @Override
    public void onClick(View v) {

        switch (v.getId()) {
            case R.id.btn_take_photo:
                manager.takePhotos();
                break;

            case R.id.btn_stop_photo:
                manager.stopTakingPhotos();
                break;
            case R.id.btn_take_off:
                manager.addTakeOffMission();
                break;

            case R.id.btn_land:
                manager.addLandMission();
                break;

            case R.id.btn_init:
                Thread t = new Thread(new Runnable() {
                    @Override
                    public void run() {
                        Logger.sendData("hello");
                    }
                });
                t.start();
                updateTitleBar();
                manager = TaskManager.getInstance();
                break;

            case R.id.btn_go_to_waypont:
//                goByWaypoint();
                manager.addGoToWaypointMission(113.9590f,22.5430f,10.0f);

                break;

            case R.id.btn_stop_mission:
                manager.stopAllMissions();
                break;

            case R.id.btn_home:
                manager.addGoHomeMission();
                break;

            case R.id.exit:
                finish();
                System.exit(0);
                break;

            case R.id.btn_rotate:
                manager.moveGimbal(0.0f,0.0f,10.0f);
                break;
        }
    }

    private void startSDKRegistration() {
        if (isRegistrationInProgress.compareAndSet(false, true)) {
            AsyncTask.execute(new Runnable() {
                @Override
                public void run() {
                    showToast("registering, pls wait...");

                    DJISDKManager.getInstance().registerApp(SimulatorActivity.this.getApplicationContext(), new DJISDKManager.SDKManagerCallback() {
                        @Override
                        public void onRegister(DJIError djiError) {
                            if (djiError == DJISDKError.REGISTRATION_SUCCESS) {
                                showToast("Register Success");
                                DJISDKManager.getInstance().startConnectionToProduct();
                            } else {
                                showToast("Register sdk fails, please check the bundle id and network connection!");
                            }
                            Log.v(TAG, djiError.getDescription());
                        }

                        @Override
                        public void onProductDisconnect() {
                            Log.d(TAG, "onProductDisconnect");
                            showToast("Product Disconnected");
                            notifyStatusChange();

                        }
                        @Override
                        public void onProductConnect(BaseProduct baseProduct) {
                            Log.d(TAG, String.format("onProductConnect newProduct:%s", baseProduct));
                            showToast("Product Connected");
                            notifyStatusChange();

                        }

                        @Override
                        public void onProductChanged(BaseProduct baseProduct) {

                        }

                        @Override
                        public void onComponentChange(BaseProduct.ComponentKey componentKey, BaseComponent oldComponent,
                                                      BaseComponent newComponent) {

                            if (newComponent != null) {
                                newComponent.setComponentListener(new BaseComponent.ComponentListener() {

                                    @Override
                                    public void onConnectivityChange(boolean isConnected) {
                                        Log.d(TAG, "onComponentConnectivityChanged: " + isConnected);
                                        notifyStatusChange();
                                    }
                                });
                            }
                            Log.d(TAG,
                                    String.format("onComponentChange key:%s, oldComponent:%s, newComponent:%s",
                                            componentKey,
                                            oldComponent,
                                            newComponent));

                        }

                        @Override
                        public void onInitProcess(DJISDKInitEvent djisdkInitEvent, int i) {

                        }

                        @Override
                        public void onDatabaseDownloadProgress(long l, long l1) {

                        }

                    });
                }
            });
        }
    }

    private void notifyStatusChange() {
        mHandler.removeCallbacks(updateRunnable);
        mHandler.postDelayed(updateRunnable, 500);
    }

    private Runnable updateRunnable = new Runnable() {

        @Override
        public void run() {
            Intent intent = new Intent(FLAG_CONNECTION_CHANGE);
            sendBroadcast(intent);
        }
    };

    private void showToast(final String toastMsg) {

        Handler handler = new Handler(Looper.getMainLooper());
        handler.post(new Runnable() {
            @Override
            public void run() {
                Toast.makeText(getApplicationContext(), toastMsg, Toast.LENGTH_LONG).show();
            }
        });

    }
}