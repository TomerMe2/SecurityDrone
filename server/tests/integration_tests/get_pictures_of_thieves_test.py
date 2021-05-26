import json
import codecs
import sys
import unittest
import datetime
from config import config
from apis.user_communication import app as app_user
from apis.mediator_communication import app as app_mediator
import cv2
import pymongo
import os
from tests.tests_utils import create_test_user_and_delete_prev, get_token

file_path = os.path.dirname(os.path.abspath(__file__))
upload_images_url = '/image'
get_images_url = '/pictures_of_thieves?date_from={}&date_until={}&index_from={}&index_until={}'


class TestGetPicturesOfThieves(unittest.TestCase):
    mediator_test_client = None
    user_test_client = None
    NUMBER_OF_IMGS_IN_DB = 6

    @classmethod
    def setUpClass(cls):
        cls.mediator_test_client = app_mediator.test_client()
        cls.user_test_client = app_user.test_client()

        db_client = pymongo.MongoClient(config['db_url'])
        db = db_client[config['app_db_client_name']]
        col = db[config['thief_images_db_name']]
        col.delete_many({})

        create_test_user_and_delete_prev()
        cls.token = get_token(cls.user_test_client)

        # picture with a man in it
        img = cv2.imread(f'{file_path}/../dune-sand-man-desert.jpg')
        # encode image as jpeg
        _, img_encoded = cv2.imencode('.jpeg', img)
        string_of_img = img_encoded.tostring()
        cls.img_in_base64 = codecs.encode(string_of_img, 'base64').decode()

        cls.base_lat = 34.12
        cls.base_lon = 31.11
        for i in range(cls.NUMBER_OF_IMGS_IN_DB):
            # send http request with image and receive response
            response = cls.mediator_test_client.post(upload_images_url, data=json.dumps({
                'image': cls.img_in_base64,
                'lat': cls.base_lat + i,
                'lon': cls.base_lon + i
            }))
            assert response.status_code == 200

    @classmethod
    def tearDownClass(cls):
        cls.mediator_test_client.__exit__(*sys.exc_info())  # hack to mimic the behavior of "with" statement
        cls.user_test_client.__exit__(*sys.exc_info())

    def test_get_thieves_pictures(self):
        """
        Checks that we can get images in the correct order
        :return:
        """

        # now we got a filled db
        # let's test the endpoint
        time_now = datetime.datetime.now()
        time_yesterday = (time_now - datetime.timedelta(days=1)).strftime('%d_%m_%Y')
        time_tomorrow = (time_now + datetime.timedelta(days=1)).strftime('%d_%m_%Y')

        response = self.user_test_client.get(get_images_url.format(time_yesterday, time_tomorrow, 0, 3), headers={
            'x-access-tokens': self.token
        })
        assert response.status_code == 200

        response_data = response.json
        assert len(response_data) == 3
        for i, obj in enumerate(response_data):
            assert obj['image'] == self.img_in_base64
            assert obj['lat'] == self.base_lat + self.NUMBER_OF_IMGS_IN_DB - 1 - i
            assert obj['lon'] == self.base_lon + self.NUMBER_OF_IMGS_IN_DB - 1 - i

    def test_get_thieves_pictures_middle(self):
        """
        Checks that fetching images in middle works
        :return:
        """

        # now we got a filled db
        # let's test the endpoint
        time_now = datetime.datetime.now()
        time_yesterday = (time_now - datetime.timedelta(days=1)).strftime('%d_%m_%Y')
        time_tomrrow = (time_now + datetime.timedelta(days=1)).strftime('%d_%m_%Y')

        response = self.user_test_client.get(get_images_url.format(time_yesterday, time_tomrrow, 3, 5), headers={
            'x-access-tokens': self.token
        })
        assert response.status_code == 200

        response_data = response.json
        assert len(response_data) == 2
        for i, obj in enumerate(response_data):
            assert obj['image'] == self.img_in_base64
            assert obj['lat'] == self.base_lat + self.NUMBER_OF_IMGS_IN_DB - 1 - i - 3
            assert obj['lon'] == self.base_lon + self.NUMBER_OF_IMGS_IN_DB - 1 - i - 3


if __name__ == "__main__":
    unittest.main()
