package components;

import Utils.Config;
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

    public void takeOff(){
        mFlightController.startTakeoff(
                new  CommonCallbacks.CompletionCallback() {
                    @Override
                    public void onResult(DJIError djiError) {
                        if (djiError != null) {
                            //TODO add what to do when there is error
                        } else {
                            //TODO add what to do when there is success
                        }
                    }
                }
        );
    }
    public void cancelTakeOff(){
        mFlightController.cancelTakeoff(
                new  CommonCallbacks.CompletionCallback() {
                    @Override
                    public void onResult(DJIError djiError) {
                        if (djiError != null) {
                            //TODO add what to do when there is error
                        } else {
                            //TODO add what to do when there is success
                        }
                    }
                }
        );
    }

    public void goHome(){
        mFlightController.startGoHome( new  CommonCallbacks.CompletionCallback() {
            @Override
            public void onResult(DJIError djiError) {
                if (djiError != null) {
                    //TODO add what to do when there is error
                } else {
                    //TODO add what to do when there is success
                }
            }
        });
    }

    public void setHome(LocationCoordinate2D loc){
        mFlightController.setHomeLocation(loc, new CommonCallbacks.CompletionCallback() {
            @Override
            public void onResult(DJIError djiError) {
                if (djiError != null) {
                    //TODO add what to do when there is error
                } else {
                    //TODO add what to do when there is success
                }
            }
        });
    }


    public void stopGoHome(){
        mFlightController.cancelGoHome(new CommonCallbacks.CompletionCallback() {
            @Override
            public void onResult(DJIError djiError) {

                if (djiError!= null){
                    //TODO add what to do when there is error
                }
                else{
                    //TODO add what to do when there is success
                }
            }
        });
    }

    public FlightControllerState getDroneState(){
        return mFlightControllerState;
    }

    public void startLanding(){
        landing= true;
        mFlightController.startLanding(new CommonCallbacks.CompletionCallback() {
            @Override
            public void onResult(DJIError djiError) {

                if (djiError!= null){
                    //TODO add what to do when there is error
                }
                else{
                    long startTime = System.currentTimeMillis();
                    while (!isFinishedLanding() && landing){
                        if(System.currentTimeMillis() - startTime > Config.MAX_TIME_WAIT_FOR_LANDING){
                            //TODO do if max time passed
                        }
                        try {
                            Thread.sleep(1000);
                        } catch (InterruptedException e) {
                        }
                    }
                    //TODO do when finished landing
                }
            }
        });
    }

    private boolean isFinishedLanding(){
        return getDroneState().isLandingConfirmationNeeded() || !mFlightController.getState().areMotorsOn();
    }

    public LocationCoordinate2D getLocation(){
        LocationCoordinate3D currentLocation = mFlightControllerState.getAircraftLocation();
        double longitude = currentLocation.getLongitude();
        double latitude = currentLocation.getLatitude();
        LocationCoordinate2D currentLocation2D = new LocationCoordinate2D(latitude,longitude);
        return currentLocation2D;
    }

    public void stopLanding() {
        landing = false;
        mFlightController.cancelLanding(new CommonCallbacks.CompletionCallback() {
            @Override
            public void onResult(DJIError djiError) {
                if (djiError!= null){
                    //TODO add what to do when there is error
                }
                else{
                    //TODO add what to do when there is success
                }
            }
        });
    }

}
