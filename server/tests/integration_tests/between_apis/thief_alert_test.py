import sys
import unittest
from apis.mediator_communication import socketio as mediator_socketio, app as mediator_app
from apis.user_communication import socketio as user_socketio, app as user_app
from apis.apis_connector import MockApisConnector
import cv2
from tests.tests_utils import make_json_from
import os


file_path = os.path.dirname(os.path.abspath(__file__))
send_img_url = '/image'


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

    def test_thief_alert(self):
        # picture with a man in it
        img = cv2.imread(f'{file_path}/../../dune-sand-man-desert.jpg')
        # encode image as jpeg
        _, img_encoded = cv2.imencode('.jpeg', img)
        string_of_img = img_encoded.tostring()
        # send http request with image and receive response
        response = self.test_client_flask_mediator.post(send_img_url, data=make_json_from(string_of_img))

        assert response.status_code == 200

        # check that the mediator sent the response
        socket_response = self.apis_connector.socket_mediator.get_received()
        assert len(socket_response) == 1
        assert socket_response[0]['name'] == 'thief_found'

    def test_no_thief_no_alert(self):
        # picture with a man in it
        img = cv2.imread(f'{file_path}/../../field-from-drone-view-no-humans.jpg')
        # encode image as jpeg
        _, img_encoded = cv2.imencode('.jpeg', img)
        string_of_img = img_encoded.tostring()
        # send http request with image and receive response
        response = self.test_client_flask_mediator.post(send_img_url, data=make_json_from(string_of_img))

        assert response.status_code == 200

        # check that the mediator didn't send the response
        socket_response = self.apis_connector.socket_mediator.get_received()
        assert len(socket_response) == 0


if __name__ == "__main__":
    unittest.main()
