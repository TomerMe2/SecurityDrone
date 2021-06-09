from socketIO_client import SocketIO, LoggingNamespace
from datetime import datetime
from busniess_layer.logic_controller import LogicController
from config import config


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
        self.socket_user.on('patrol_time', self.send_patrol)
        self.socket_user.on('patrol', self.send_patrol)
        self.socket_mediator.wait()
        self.socket_user.wait()

    def thief_found(self, img_json):
        self.socket_user.emit('notify_thief', img_json)

    def send_patrol(self):
        logic = LogicController()
        logic.start_patrol_user_request(datetime.now())

    def patrol_time(self):
        # should start patrol because of time interval
        logic = LogicController()
        logic.start_patrol_time_interval(datetime.now())


