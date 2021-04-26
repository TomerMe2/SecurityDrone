import sys
import json
import pymongo
import unittest
from apis.user_communication import app
from config import config

# quick ref for mongod for sanity:
# C:\Program Files\MongoDB\Server\4.4\bin\mongod.exe
test_url = '/update_waypoints'


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

    @classmethod
    def tearDownClass(cls):
        cls.test_client.__exit__(*sys.exc_info())   # hack to mimic the behavior of "with" statement

    def check_for_waypoints(self, waypoints):
        data = json.dumps(waypoints)
        response = self.test_client.post(test_url, data=data)

        assert response.status_code == 200

        db_client = pymongo.MongoClient(config['db_url'])
        db = db_client[config['app_db_client_name']]
        col = db[config['waypoints_db_name']]
        waypoints_from_db = list(col.find())

        assert compare_lst_from_db(waypoints, waypoints_from_db)

        db_client.close()

    def test_update_waypoint_test1(self):
        waypoint1 = {'latitude': 29.36, 'longitude': 30.55}
        waypoint2 = {'latitude': 33.36, 'longitude': 31.55}
        waypoints = [waypoint1, waypoint2]
        self.check_for_waypoints(waypoints)

    def test_update_waypoint_test2(self):
        waypoint2 = {'latitude': 33.36, 'longitude': 31.55}
        waypoint3 = {'latitude': 41.36, 'longitude': 14.55}
        waypoint4 = {'latitude': 39.11, 'longitude': 25.25}
        waypoints = [waypoint2, waypoint3, waypoint4]
        self.check_for_waypoints(waypoints)


if __name__ == '__main__':
    unittest.main()
