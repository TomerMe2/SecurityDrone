from socketIO_client import SocketIO, LoggingNamespace
from config import config
import logic
import json

def thief_found(img_json):
    socket_user.emit('notify_thief',img_json)

def send_patrol():
    l = logic.logic_controller()
    waypoints = l.get_waypoints()
    json_waypoints = json.dumps(waypoints)
    socket_user.emit('send_patrol',json_waypoints)


socket_med = SocketIO('localhost', config['mediator_api_port'], LoggingNamespace)
socket_user = SocketIO('localhost',config['user_api_port'], LoggingNamespace)
socket_med.emit('join_admin')
socket_user.emit('join_admin')
socket_med.on('thief_found',thief_found)
socket_user.on('patrol',send_patrol)
socket_med.wait()
socket_user.wait()
