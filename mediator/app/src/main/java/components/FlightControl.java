package components;

import Utils.Config;
import Utils.MissionState;
import dji.common.error.DJIError;
import dji.common.flightcontroller.LocationCoordinate3D;
import dji.common.model.LocationCoordinate2D;
import dji.common.util.CommonCallbacks;
import dji.sdk.products.Aircraft;
import dji.sdk.flightcontroller.FlightController;
import dji.common.flightcontroller.FlightControllerState;

public class FlightControl {
    private FlightController mFlightController;
    private FlightControllerState mFlightControllerState;
    private boolean landing = false;

    public FlightControl(Aircraft aircraft){
        mFlightController= aircraft.getFlightController();
        if(mFlightController != null){
            mFlightControllerState = mFlightController.getState();
        }
    }

    public void takeOff(MissionState state){
        mFlightController.startTakeoff(
                new  CommonCallbacks.CompletionCallback() {
                    @Override
                    public void onResult(DJIError djiError) {
                        if (djiError != null) {
                            state.fail();
                        } else {
                            state.success();
                        }
                    }
                }
        );
    }
    public void cancelTakeOff(MissionState state){
        mFlightController.cancelTakeoff(
                new  CommonCallbacks.CompletionCallback() {
                    @Override
                    public void onResult(DJIError djiError) {
                        if (djiError != null) {
                            state.fail();
                        } else {
                            state.success();
                        }
                    }
                }
        );
    }

    public void goHome(MissionState state){
        mFlightController.startGoHome( new  CommonCallbacks.CompletionCallback() {
            @Override
            public void onResult(DJIError djiError) {
                if (djiError != null) {
                    state.fail();
                } else {
                    state.success();
                }
            }
        });
    }

    public void setHome(LocationCoordinate2D loc,MissionState state){
        mFlightController.setHomeLocation(loc, new CommonCallbacks.CompletionCallback() {
            @Override
            public void onResult(DJIError djiError) {
                if (djiError != null) {
                    state.fail();
                } else {
                    state.success();
                }
            }
        });
    }


    public void stopGoHome(MissionState state){
        mFlightController.cancelGoHome(new CommonCallbacks.CompletionCallback() {
            @Override
            public void onResult(DJIError djiError) {

                if (djiError!= null){
                    state.fail();
                }
                else{
                    state.success();
                }
            }
        });
    }

    public FlightControllerState getDroneState(){
        return mFlightControllerState;
    }

    public void startLanding(MissionState state){
        landing= true;
        mFlightController.startLanding(new CommonCallbacks.CompletionCallback() {
            @Override
            public void onResult(DJIError djiError) {

                if (djiError!= null){
                    state.fail();
                }
                else{
                    long startTime = System.currentTimeMillis();
                    while (!isFinishedLanding() && landing){
                        if(System.currentTimeMillis() - startTime > Config.MAX_TIME_WAIT_FOR_LANDING){
                            state.fail();
                        }
                        try {
                            Thread.sleep(1000);
                        } catch (InterruptedException e) {
                        }
                    }
                    state.success();
                }
            }
        });
    }

    private boolean isFinishedLanding(){
        return getDroneState().isLandingConfirmationNeeded() || !mFlightController.getState().areMotorsOn();
    }

    public LocationCoordinate2D getLocation(MissionState state){
        LocationCoordinate3D currentLocation = mFlightControllerState.getAircraftLocation();
        double longitude = currentLocation.getLongitude();
        double latitude = currentLocation.getLatitude();
        LocationCoordinate2D currentLocation2D = new LocationCoordinate2D(latitude,longitude);
        return currentLocation2D;
    }

    public void stopLanding(MissionState state) {
        landing = false;
        mFlightController.cancelLanding(new CommonCallbacks.CompletionCallback() {
            @Override
            public void onResult(DJIError djiError) {
                if (djiError!= null){
                    state.fail();
                }
                else{
                    state.success();
                }
            }
        });
    }

}
