# from socketIO_client import SocketIO
import sys
import unittest
import datetime
from config import config
from apis.mediator_communication import app
import cv2
import pymongo
from tests.tests_utils import make_json_from
import os


file_path = os.path.dirname(os.path.abspath(__file__))
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
        """
        This tests checks that a single image of a thief is saved into the db
        :return:
        """
        db_client = pymongo.MongoClient(config['db_url'])
        db = db_client[config['app_db_client_name']]
        col = db[config['thief_images_db_name']]
        col.delete_many({})

        # picture with a man in it
        img = cv2.imread(f'{file_path}/../dune-sand-man-desert.jpg')
        # encode image as jpeg
        _, img_encoded = cv2.imencode('.jpeg', img)
        string_of_img = img_encoded.tostring()
        # send http request with image and receive response
        response = self.test_client.post(test_url, data=make_json_from(string_of_img, 34.12, 31.11))

        assert response.status_code == 200

        images_from_db = list(col.find())
        assert len(images_from_db) == 1

        image_from_db = images_from_db[0]
        # check that the insertion date is correct
        assert image_from_db['date'] > datetime.datetime.now() - datetime.timedelta(seconds=10)
        # check that the image data is correct
        assert image_from_db['image'] == string_of_img
        assert image_from_db['lat'] == 34.12
        assert image_from_db['lon'] == 31.11

    def test_thief_picture_not_overriding(self):
        """
        This test checks that insertion of a new thief image doesn't delete the previous images
        """
        db_client = pymongo.MongoClient(config['db_url'])
        db = db_client[config['app_db_client_name']]
        col = db[config['thief_images_db_name']]
        col.delete_many({})

        # picture with a man in it
        img = cv2.imread(f'{file_path}/../dune-sand-man-desert.jpg')
        # encode image as jpeg
        _, img_encoded = cv2.imencode('.jpeg', img)
        string_of_img = img_encoded.tostring()
        # send http request with image and receive response
        response = self.test_client.post(test_url, data=make_json_from(string_of_img, 34.12, 31.11))

        assert response.status_code == 200

        images_from_db = list(col.find())
        assert len(images_from_db) == 1

        image_from_db = images_from_db[0]
        assert image_from_db['image'] == string_of_img

        response = self.test_client.post(test_url, data=make_json_from(string_of_img, 34.12, 31.11))

        assert response.status_code == 200

        images_from_db = list(col.find())
        assert len(images_from_db) == 2

        assert all([image_from_db['image'] == string_of_img and
                    image_from_db['date'] > datetime.datetime.now() - datetime.timedelta(seconds=10)
                    for image_from_db in images_from_db])

    def test_no_thief(self):
        db_client = pymongo.MongoClient(config['db_url'])
        db = db_client[config['app_db_client_name']]
        col = db[config['thief_images_db_name']]
        col.delete_many({})

        # picture with a man in it
        img = cv2.imread(f'{file_path}/../field-from-drone-view-no-humans.jpg')
        # encode image as jpeg
        _, img_encoded = cv2.imencode('.jpeg', img)
        string_of_img = img_encoded.tostring()
        # send http request with image and receive response
        response = self.test_client.post(test_url, data=make_json_from(string_of_img, 34.12, 31.11))

        assert response.status_code == 200

        images_from_db = list(col.find())
        assert len(images_from_db) == 0


if __name__ == "__main__":
    unittest.main()
