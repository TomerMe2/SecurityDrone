from flask import Flask,request
from flask_socketio import SocketIO,send,emit
import cv2
import numpy as np
import mission
import matplotlib.pyplot as plt
from PIL import Image

app = Flask(__name__)
socketio = SocketIO(app)

def patrol(waypoints):
    socketio.emit('patrol', waypoints)

@app.route('/image', methods=('POST',))
def analys_photo():
    r = request
    # convert string of image data to uint8
    nparr = np.frombuffer(r.data, np.uint8)
    # decode image
    img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)
    im = Image.fromarray(img, 'RGB')
    m = mission.MissionController()
    m.add_thief(im)
    return 'true'

if __name__ == "__main__":
    socketio.run(port=5001,app=app)