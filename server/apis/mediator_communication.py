from flask import Flask, request, g
from flask_socketio import SocketIO, emit, join_room
from apis.api_utils import do_and_return_response
from config import config
from busniess_layer.logic_controller import LogicController
from datetime import datetime
from object_detection.yolov5_adapter import YoloAdapter
import codecs

app = Flask(__name__)
socketio = SocketIO(app)


# handle yolo adapter as a singleton, to save RAM and save CPU time loading weights into the RAM each time a flask
# process is spawned
def get_object_detector():
    if 'object_detector' not in g:
        g.object_detector = YoloAdapter()

    return g.object_detector


@socketio.on('join_mediator')
def on_join_mediator():
    join_room('mediator')


@socketio.on('join_connector')
def on_join_connector():
    join_room('connector')


@socketio.on('send_patrol')
def patrol(waypoints):
    emit('patrol', waypoints, room='mediator')


@app.route('/image', methods=['POST'])
def process_image():
    current_date = datetime.now()
    request_json = request.get_json(force=True)
    image = codecs.decode(request_json['image'].encode(), 'base64')
    lat = request_json['lat']
    lon = request_json['lon']
    return do_and_return_response(lambda: process_and_notify_if_thief(current_date, image, lat, lon))


def process_and_notify_if_thief(current_date, img_in_string, lat_of_img, lon_of_img):
    logic_controller = LogicController()
    is_there_thief, is_successful = logic_controller.process_image(img_in_string, current_date,
                                                                   lat_of_img, lon_of_img, get_object_detector())

    if is_there_thief:
        socketio.emit('thief_found', room='connector', data=img_in_string)

    return is_successful


if __name__ == "__main__":
    socketio.run(port=config['mediator_api_port'], app=app)