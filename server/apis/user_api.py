from flask import Flask, request, Response
from flask_socketio import SocketIO, emit, join_room

from apis.api_utils import do_and_return_response
from logic.logic_controller import LogicController
from config import config

app = Flask(__name__)
socketio = SocketIO(app)


@socketio.on('join_us')
def on_join_us():
    join_room('us')


@socketio.on('join_connector')
def on_join_ad():
    join_room('connector')


@socketio.on('notify_thief')
def notify(im_json):
    emit('thief_found',im_json,room='user')


@app.route('/update_waypoints', methods=['POST'])
def update_waypoints():
    waypoints = request.get_json(force=True)

    logic_controller = LogicController()

    return do_and_return_response(lambda: logic_controller.update_waypoints(waypoints))


@app.route('/patrol', methods=('POST',))
def send_patrol():
    emit('patrol',room='admin')
    return ''


if __name__ == "__main__":
    socketio.run(port=config['user_api_port'],app=app)


