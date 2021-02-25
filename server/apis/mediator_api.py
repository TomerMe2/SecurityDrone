from flask import Flask, request, g
from flask_socketio import SocketIO, emit, join_room
import cv2
import numpy as np

from apis.api_utils import do_and_return_response
from config import config
from logic.logic_controller import LogicController
from datetime import datetime
from object_detection.yolov5_adapter import YoloAdapter

app = Flask(__name__)
socketio = SocketIO(app)


# handle yolo adapter as a singleton, to save RAM and save CPU time loading weights into the RAM each time a flask
# process is spawned
def get_object_detector():
    if 'object_detector' not in g:
        g.object_detector = YoloAdapter()

    return g.object_detector


@socketio.on('join_mediator')
def on_join_med():
    join_room('mediator')


@socketio.on('join_admin')
def on_join_ad():
    join_room('admin')


@socketio.on('send_patrol')
def patrol(waypoints):
    emit('patrol', waypoints, room='med')


@app.route('/image', methods=['POST'])
def process_image():
    current_date = datetime.now()

    logic_controller = LogicController()
    return do_and_return_response(lambda: logic_controller.process_image(request.data, current_date, get_object_detector()))


if __name__ == "__main__":
    socketio.run(port=config['mediator_api_port'], app=app)