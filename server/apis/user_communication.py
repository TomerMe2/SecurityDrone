import codecs

from flask import Flask, request, Response
from flask_socketio import SocketIO, emit, join_room

from apis.api_utils import do_and_return_response
from busniess_layer.logic_controller import LogicController
from config import config
import datetime
from flask import jsonify
import jwt
from functools import wraps

app = Flask(__name__)
socketio = SocketIO(app)
app.config['SECRET_KEY'] = 'Th1s1ss3cr3t_NOT_FOR_PROD'
jwt_algorithm = 'HS256'


def token_required(f):
    @wraps(f)
    def decorator(*args, **kwargs):

        if 'x-access-tokens' not in request.headers:
            return jsonify({'message': 'a valid token is missing'})

        token = request.headers['x-access-tokens']

        try:
            data = jwt.decode(token, app.config['SECRET_KEY'], algorithms=[jwt_algorithm])

            controller = LogicController()
            if controller.is_username_exists(data['username']):
                return f(*args, **kwargs)

            return jsonify({'message': 'token is invalid'})

        except:
            return jsonify({'message': 'token is invalid'})

    return decorator


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
@token_required
def update_waypoints():
    waypoints = request.get_json(force=True)

    logic_controller = LogicController()

    return do_and_return_response(lambda: logic_controller.update_waypoints(waypoints))


@app.route('/request_patrol_mission', methods=('POST',))
@token_required
def request_patrol_mission():
    socketio.emit('patrol_request', room='connector')
    # TODO: handle this with flight initiate
    return do_and_return_response(lambda: True)


@app.route('/request_abort_mission', methods=['POST'])
@token_required
def request_abort_mission():
    socketio.emit('abort_mission', room='connector')
    # TODO: handle this
    return do_and_return_response(lambda: True)


@app.route('/login', methods=['POST'])
def login():
    # params: username, password
    # returns: response with code 401 for unsuccessful login.
    # json with {token} for successful login
    # password should be plaintext. This is fine since on production the server should run on HTTPS, and it encrypts
    # the requests from end to end.
    request_json = request.get_json(force=True)

    if 'username' not in request_json or 'password' not in request_json:
        return Response(status=400)

    username = request_json['username']
    plaintext_password = request_json['password']

    controller = LogicController()
    if controller.can_login(username, plaintext_password):
        token = jwt.encode(
            {'username': username,
             'exp': datetime.datetime.utcnow() + datetime.timedelta(minutes=30)},
            app.config['SECRET_KEY'],
            algorithm=jwt_algorithm
        )
        return jsonify({'token': token})

    return Response(status=401)


@app.route('/pictures_of_thieves', methods=('GET',))
@token_required
def get_pictures_of_thieves():
    # parameters: date_from, date_until, index_from, index_until
    # returns: a list, each entry is {image, date, lat, lon} where image is base64 encoded.
    # dates are formatted using d_m_Y
    # for example: 8_9_2018

    date_from = request.args.get('date_from')
    date_until = request.args.get('date_until')
    index_from = request.args.get('index_from')
    index_until = request.args.get('index_until')

    try:
        if date_from is not None:
            date_from = datetime.datetime.strptime(date_from, '%d_%m_%Y')
        if date_until is not None:
            date_until = datetime.datetime.strptime(date_until, '%d_%m_%Y')
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
    socketio.run(port=config['user_api_port'], app=app)
