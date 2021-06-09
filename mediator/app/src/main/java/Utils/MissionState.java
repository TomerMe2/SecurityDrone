package Utils;

public class MissionState {
    private State state;
    private String failMsg = "";
    public MissionState(){
        this.state = State.Pending;
    }
    public void success(){
        synchronized (state){
            state = State.Success;
        }
    }

    public void fail(String msg){
        synchronized (state){
            state = State.Fail;
        }
        failMsg = msg;
    }

    public String getFailMsg(){
        return failMsg;
    }

    public State currentState(){
        synchronized (state){
            return state;
        }
    }
}
