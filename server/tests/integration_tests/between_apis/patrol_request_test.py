import sys
import unittest
from apis.mediator_communication import socketio as mediator_socketio, app as mediator_app
from apis.user_communication import socketio as user_socketio, app as user_app
from apis.apis_connector import MockApisConnector

patrol_request_url = '/patrol'


class TestThiefAlert(unittest.TestCase):
    test_client_flask_user = None
    test_client_flask_mediator = None
    apis_connector = None

    @classmethod
    def setUpClass(cls):
        cls.test_client_flask_mediator = mediator_app.test_client()
        test_client_socketio_mediator = mediator_socketio.test_client(mediator_app,
                                                                      flask_test_client=cls.test_client_flask_mediator)
        cls.test_client_flask_user = user_app.test_client()
        test_client_socketio_user = user_socketio.test_client(user_app,
                                                              flask_test_client=cls.test_client_flask_user)

        cls.apis_connector = MockApisConnector(test_client_socketio_mediator, test_client_socketio_user)

    @classmethod
    def tearDownClass(cls):
        cls.test_client_flask_mediator.__exit__(*sys.exc_info())

    def test_patrol_request(self):
        response = self.test_client_flask_user.post(patrol_request_url)
        assert response.status_code == 200

        # check that the mediator sent the response
        socket_response = self.apis_connector.socket_user.get_received()
        assert len(socket_response) == 1
        assert socket_response[0]['name'] == 'patrol_request'


if __name__ == "__main__":
    unittest.main()
