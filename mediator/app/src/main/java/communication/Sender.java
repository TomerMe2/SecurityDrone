package communication;

import android.graphics.Bitmap;

public interface Sender {

    void sendLoc(float latitude, float longitude);

    void sendDone();

    void sendPic(Bitmap pic);
}
