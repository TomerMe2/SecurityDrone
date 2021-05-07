import codecs

from flask import Flask, request, Response
from flask_socketio import SocketIO, emit, join_room

from apis.api_utils import do_and_return_response
from busniess_layer.logic_controller import LogicController
from config import config
from datetime import datetime
from flask import jsonify


app = Flask(__name__)
socketio = SocketIO(app)


@socketio.on('join_user')
def on_join_us():
    join_room('user')


@socketio.on('join_connector')
def on_join_ad():
    join_room('connector')


@socketio.on('notify_thief')
def notify(im_json):
    emit('thief_found', im_json, room='user')


@app.route('/update_waypoints', methods=['POST'])
def update_waypoints():
    waypoints = request.get_json(force=True)

    logic_controller = LogicController()

    return do_and_return_response(lambda: logic_controller.update_waypoints(waypoints))


@app.route('/patrol', methods=('POST',))
def send_patrol():
    socketio.emit('patrol_request', room='connector')
    # TODO: handle this with flight initiate
    return do_and_return_response(lambda: True)


@app.route('/pictures_of_thieves', methods=('GET',))
def get_pictures_of_thieves():
    # dates are formatted using d_m_Y
    # for example: 8_9_2018

    date_from = request.args.get('date_from')
    date_until = request.args.get('date_until')
    index_from = request.args.get('index_from')
    index_until = request.args.get('index_until')

    try:
        if date_from is not None:
            date_from = datetime.strptime(date_from, '%d_%m_%Y')
        if date_until is not None:
            date_until = datetime.strptime(date_until, '%d_%m_%Y')
        if index_from is not None:
            index_from = int(index_from)
        if index_until is not None:
            index_until = int(index_until)
    except ValueError:
        return Response(status=400)

    logic_controller = LogicController()
    imgs_with_date = logic_controller.get_images_of_thieves(date_from, date_until, index_from, index_until)
    for obj in imgs_with_date:
        # turning into base64
        obj['image'] = codecs.encode(obj['image'], 'base64').decode()
        obj['date'] = obj['date'].strftime('%d_%m_%Y')

    return jsonify(imgs_with_date)


if __name__ == "__main__":
    socketio.run(port=config['user_api_port'],app=app)


