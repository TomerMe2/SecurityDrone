from flask import Flask,request
from flask_socketio import SocketIO,send,emit
import cv2
import numpy as np
import mission

app = Flask(__name__)
socketio = SocketIO(app, async_mode=None)

@app.route('/image', methods=('POST',))
def analys_photo(data):
    r = request
    # convert string of image data to uint8
    nparr = np.fromstring(r.data, np.uint8)
    # decode image
    img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)
    m=mission.mission_controller()
    m.add_thief(img)

if __name__ == "__main__":
    socketio.run(port=5001,app=app)