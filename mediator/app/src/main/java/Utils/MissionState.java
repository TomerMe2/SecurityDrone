package Utils;

public class MissionState {
    private State state;
    public MissionState(){
        this.state = State.Pending;
    }
    public void success(){
        synchronized (state){
            state = State.Success;
        }
    }

    public void fail(){
        synchronized (state){
            state = State.Fail;
        }
    }

    public State currentState(){
        synchronized (state){
            return state;
        }
    }
}
