import sys
import json
import pymongo
import unittest
from apis.user_communication import app
from config import config

# quick ref for mongod for sanity:
# C:\Program Files\MongoDB\Server\4.4\bin\mongod.exe
from tests.tests_utils import create_test_user_and_delete_prev, get_token

set_test_url = '/update_waypoints'
get_test_url = '/get_patrol_waypoints'


def compare_lst_from_db(true_lst, lst_from_db):
    copied_lst_from_db = lst_from_db.copy()
    for dct in copied_lst_from_db:
        del dct['_id']

    return copied_lst_from_db == true_lst


class TestWaypointsUpdate(unittest.TestCase):
    test_client = None

    @classmethod
    def setUpClass(cls):
        cls.test_client = app.test_client()
        create_test_user_and_delete_prev()
        cls.token = get_token(cls.test_client)

    @classmethod
    def tearDownClass(cls):
        cls.test_client.__exit__(*sys.exc_info())   # hack to mimic the behavior of "with" statement

    def check_for_waypoints(self, waypoints):
        data = json.dumps(waypoints)
        response = self.test_client.post(set_test_url, data=data, headers={
            'x-access-tokens': self.token
        })
        assert response.status_code == 200

        db_client = pymongo.MongoClient(config['db_url'])
        db = db_client[config['app_db_client_name']]
        col = db[config['waypoints_db_name']]
        waypoints_from_db = list(col.find())

        assert compare_lst_from_db(waypoints, waypoints_from_db)

        db_client.close()

        response_get = self.test_client.get(get_test_url, data=data, headers={
            'x-access-tokens': self.token
        })
        assert response_get.status_code == 200
        waypoints_from_api = response_get.json

        assert waypoints == waypoints_from_api



    def test_update_waypoint_test1(self):
        waypoint1 = {'lat': 29.36, 'lon': 30.55}
        waypoint2 = {'lat': 33.36, 'lon': 31.55}
        waypoints = [waypoint1, waypoint2]
        self.check_for_waypoints(waypoints)

    def test_update_waypoint_test2(self):
        waypoint2 = {'lat': 33.36, 'lon': 31.55}
        waypoint3 = {'lat': 41.36, 'lon': 14.55}
        waypoint4 = {'lat': 39.11, 'lon': 25.25}
        waypoints = [waypoint2, waypoint3, waypoint4]
        self.check_for_waypoints(waypoints)


if __name__ == '__main__':
    unittest.main()
