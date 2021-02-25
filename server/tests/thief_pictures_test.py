# from socketIO_client import SocketIO
import sys
import unittest

from config import config
from apis.mediator_api import app

import requests
import cv2
import pymongo

test_url = '/image'


class TestMediatorApi(unittest.TestCase):
    test_client = None

    @classmethod
    def setUpClass(cls):
        cls.test_client = app.test_client()

    @classmethod
    def tearDownClass(cls):
        cls.test_client.__exit__(*sys.exc_info())  # hack to mimic the behavior of "with" statement

    def test_thief_picture(self):
        db_client = pymongo.MongoClient(config['db_url'])
        db = db_client[config['app_db_client_name']]
        col = db[config['thief_images_db_name']]
        col.delete_many({})

        # picture with a man in it
        img = cv2.imread('dune-sand-man-desert.jpg')
        # encode image as jpeg
        _, img_encoded = cv2.imencode('.jpeg', img)
        string_of_img = img_encoded.tostring()
        # send http request with image and receive response
        response = self.test_client.post(test_url, data=string_of_img, headers={'content-type': 'image/jpeg'})

        assert response.status_code == 200

        images_from_db = list(col.find())
        assert len(images_from_db) == 1

        image_from_db = images_from_db[0]
        assert image_from_db['image'] == string_of_img


if __name__ == "__main__":
    unittest.main()
