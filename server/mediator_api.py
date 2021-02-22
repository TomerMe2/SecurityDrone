from flask import Flask,request
from flask_socketio import SocketIO,send,emit,join_room
import cv2
import numpy as np
import logic
import matplotlib.pyplot as plt
from PIL import Image
from config import config

app = Flask(__name__)
socketio = SocketIO(app)

@socketio.on('join_mediator')
def on_join_med():
    join_room('mediator')

@socketio.on('join_admin')
def on_join_ad():
    join_room('admin')

@socketio.on('send_patrol')
def patrol(waypoints):
    emit('patrol',waypoints ,room='med')

@app.route('/image', methods=('POST',))
def analys_photo():
    if request.method == 'POST':
        l = logic.logic_controller()
        is_thief=l.check_image(r.data)
        if is_thief:
            emit('thief_found',room='admin')
        l.close_db()
    return ''

if __name__ == "__main__":
    socketio.run(port=config['mediator_api_port'],app=app)