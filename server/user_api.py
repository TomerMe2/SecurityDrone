from flask import Flask, request
from flask_socketio import SocketIO,send,emit,join_room
import logic
import json
from config import config
import cv2
import numpy as np
import matplotlib.pyplot as plt
from PIL import Image


app = Flask(__name__)
socketio = SocketIO(app)

@socketio.on('join_us')
def on_join_us():
    join_room('us')

@socketio.on('join_admin')
def on_join_ad():
    join_room('admin')

@socketio.on('notify_thief')
def notify(im_json):
    emit('thief_found',im_json,room='user')

@app.route('/update_waypoints', methods=('POST',))
def update_waypoints():
    if request.method == 'POST':
        waypoints = request.get_json(force=True)
        l = logic.logic_controller()
        l.update_waypoints(waypoints)
        l.close_db()
    return 'true'


@app.route('/patrol', methods=('POST',))
def send_patrol():
    emit('patrol',room='admin')
    return ''


if __name__ == "__main__":
    socketio.run(port=config['user_api_port'],app=app)


