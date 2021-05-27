import sys
import json
import pymongo
import unittest
from apis.user_communication import app
from config import config
from tests.tests_utils import create_test_user_and_delete_prev, get_token

set_test_url = '/update_home_waypoint'
get_test_url = '/get_home_waypoint'


class TestHomeWaypointsUpdate(unittest.TestCase):
    test_client = None

    @classmethod
    def setUpClass(cls):
        cls.test_client = app.test_client()
        create_test_user_and_delete_prev()
        cls.token = get_token(cls.test_client)

    @classmethod
    def tearDownClass(cls):
        cls.test_client.__exit__(*sys.exc_info())   # hack to mimic the behavior of "with" statement

    def check_for_waypoint(self, waypoint):
        data = json.dumps(waypoint)
        response = self.test_client.post(set_test_url, data=data, headers={
            'x-access-tokens': self.token
        })
        assert response.status_code == 200

        db_client = pymongo.MongoClient(config['db_url'])
        db = db_client[config['app_db_client_name']]
        col = db[config['home_waypoint_db_name']]
        home_waypoint_from_db = list(col.find({}, {'_id': 0}))[0]

        assert waypoint == home_waypoint_from_db

        db_client.close()

        response_get = self.test_client.get(get_test_url, data=data, headers={
            'x-access-tokens': self.token
        })
        assert response_get.status_code == 200
        waypoint_from_api = response_get.json

        assert waypoint == waypoint_from_api

    def test_update_home_waypoint_test1(self):
        self.check_for_waypoint({'lat': 29.36, 'lon': 30.55})

    def test_update_home_waypoint_test2(self):
        self.check_for_waypoint({'lat': 39.11, 'lon': 25.25})


if __name__ == '__main__':
    unittest.main()
