from socketIO_client import SocketIO, LoggingNamespace
from config import config
import logic
import json


class MockApisConnector:
    def __init__(self, mediator_socket_io_test_app, user_socket_io_test_app):
        self.socket_mediator = mediator_socket_io_test_app
        self.socket_user = user_socket_io_test_app
        self.socket_mediator.emit('join_connector')
        self.socket_user.emit('join_connector')


class ProductionApisConnector:
    def __init__(self):
        self.socket_mediator = SocketIO('localhost', config['mediator_api_port'], LoggingNamespace)
        self.socket_user = SocketIO('localhost', config['user_api_port'], LoggingNamespace)
        self.socket_mediator.emit('join_connector')
        self.socket_user.emit('join_connector')
        self.socket_mediator.on('thief_found', self.thief_found)
        self.socket_user.on('patrol', self.send_patrol)
        self.socket_mediator.wait()
        self.socket_user.wait()

    def thief_found(self, img_json):
        self.socket_user.emit('notify_thief', img_json)

    def send_patrol(self):
        #l = logic.logic_controller()
        #waypoints = l.get_waypoints()
        #json_waypoints = json.dumps(waypoints)
        #self.socket_user.emit('send_patrol', json_waypoints)
        pass

