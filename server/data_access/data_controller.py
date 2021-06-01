from dataclasses import asdict
from datetime import datetime

import pymongo

from data_objects.missions import Mission, EndReasonType
from config import config


class DataController:
    def __init__(self):
        self.db_client = None
        self.db = None

    def __connect_to_db(self):
        self.db_client = pymongo.MongoClient(config['db_url'])
        self.db = self.db_client[config['app_db_client_name']]

    def __close_db(self):
        self.db_client.close()
        self.db_client = None
        self.db = None

    def update_waypoints(self, waypoints):
        """
        This function is called when the user wants to update the waypoints
        THIS FUNCTION OVERRIDES THE CURRENT WAYPOINTS IN THE DB
        :param waypoints: list of maps, each map contains latitude and longitude keys
        :return: true iff the waypoints updated successfully
        """
        self.__connect_to_db()
        col = self.db[config['waypoints_db_name']]

        col.delete_many({})

        insert_lst = [{'lat': point['lat'], 'lon': point['lon']} for point in waypoints]
        inserted = col.insert_many(insert_lst)

        self.__close_db()

        # return true iff inserted the correct number of waypoints
        return len(inserted.inserted_ids) == len(waypoints)

    def save_thief_img(self, img_str, received_date, lat_of_pic, lon_of_pic):
        """
        This function is called after the ML model decided that there's a person in this picture
        :param img_str: the raw string of the data from the request
        :param received_date: the date that the server received the request at
        :param lat_of_pic: the latitude of the location of the drone when the picture was taken
        :param lon_of_pic: the longitude of the location of the drone when the picture was taken
        :return: true iff image inserted successfully
        """
        self.__connect_to_db()
        col = self.db[config['thief_images_db_name']]

        inserted = col.insert_one({'image': img_str, 'date': received_date, 'lat': lat_of_pic, 'lon': lon_of_pic})

        self.__close_db()

        return inserted.inserted_id is not None

    def add_sub_mission_to_open_mission(self, sub_mission: Mission, previous_mission_end_reason: EndReasonType, time: datetime):
        assert sub_mission.end_time is None and sub_mission.end_reason is None
        self.__connect_to_db()

        col = self.db[config['missions_db_name']]
        # Should be only one, but sort by by start_time DESC to avoid weird cases
        open_missions = list(col.find({'end_time': None}).sort([("start_time", pymongo.DESCENDING)]))

        result = False

        if len(open_missions) != 0:
            open_mission = open_missions[0]
            id_of_mission = open_mission['_id']
            del open_mission['_id']
            open_mission = Mission(**open_mission)

            # close the previous sub mission
            open_mission.sub_missions[-1].end_time = time
            open_mission.sub_missions[-1].end_reason = previous_mission_end_reason
            # add the new sub mission
            open_mission.sub_missions.append(sub_mission)

            res_from_db = col.update_one({"_id": id_of_mission}, open_mission)
            result = res_from_db.modified_count == 1

        self.__close_db()
        return result

    def end_open_mission(self, end_reason: EndReasonType, time: datetime):
        self.__connect_to_db()

        col = self.db[config['missions_db_name']]
        # Should be only one, but sort by by start_time DESC to avoid weird cases
        open_missions = list(col.find({'end_time': None}).sort([("start_time", pymongo.DESCENDING)]))

        result = False

        if len(open_missions) != 0:
            open_mission = open_missions[0]
            id_of_mission = open_mission['_id']
            del open_mission['_id']
            open_mission = Mission(**open_mission)

            # close the mission
            open_mission.end_time = time
            open_mission.end_reason = end_reason

            res_from_db = col.update_one({"_id": id_of_mission}, open_mission)
            result = res_from_db.modified_count == 1

        self.__close_db()
        return result

    def add_new_mission(self, mission: Mission):
        self.__connect_to_db()
        col = self.db[config['missions_db_name']]

        inserted = col.insert_one(asdict(mission))

        self.__close_db()

        return inserted.inserted_id is not None

    def get_open_mission(self):
        col = self.db[config['missions_db_name']]
        # Should be only one, but sort by by start_time DESC to avoid weird cases
        open_missions = list(col.find({'end_time': None}).sort([("start_time", pymongo.DESCENDING)]))

        if len(open_missions) != 0:
            open_mission = open_missions[0]
            del open_mission['_id']
            open_mission = Mission(**open_mission)
            return open_mission

        return None

    def get_missions_log(self, date_from, date_until, index_from, index_until):
        self.__connect_to_db()
        col = self.db[config['missions_db_name']]

        query_params = {}
        if date_from is not None:
            query_params['$gte'] = date_from
        if date_until is not None:
            query_params['$lte'] = date_until

        if query_params == {}:
            ans = col.find({}, {'_id': 0}).sort('start_time', -1).skip(index_from).limit(index_until - index_from)
        else:
            ans = col.find({'date': query_params}, {'_id': 0}).sort('start_time', -1). \
                skip(index_from).limit(index_until - index_from)
        ans = list(ans)

        self.__close_db()
        return ans

    def get_waypoints(self):
        """
        :return: the waypoints that currently stored in the db
        """
        self.__connect_to_db()

        col = self.db[config['waypoints_db_name']]
        waypoints = list(col.find({}, {'_id': 0}))

        self.__close_db()
        return waypoints

    def update_home_waypoint(self, lat, lon):
        self.__connect_to_db()
        col = self.db[config['home_waypoint_db_name']]

        col.delete_many({})
        inserted = col.insert_one({'lat': lat, 'lon': lon})

        self.__close_db()

        return inserted.inserted_id is not None

    def get_home_waypoint(self):
        """
        :return: the home waypoint that currently stored in the db
        """
        self.__connect_to_db()

        col = self.db[config['home_waypoint_db_name']]
        waypoint = list(col.find({}, {'_id': 0}))[0]

        self.__close_db()
        return waypoint

    def get_images_of_thieves(self, date_from, date_until, index_from, index_until):
        self.__connect_to_db()
        col = self.db[config['thief_images_db_name']]

        query_params = {}
        if date_from is not None:
            query_params['$gte'] = date_from
        if date_until is not None:
            query_params['$lte'] = date_until

        if query_params == {}:
            ans = col.find({}, {'_id': 0}).sort('date', -1).skip(index_from).limit(index_until - index_from)
        else:
            ans = col.find({'date': query_params}, {'_id': 0}).sort('date', -1). \
                skip(index_from).limit(index_until - index_from)
        ans = list(ans)

        self.__close_db()
        return ans

    def get_user(self, username):
        self.__connect_to_db()
        col = self.db[config['users_db_name']]

        ans = col.find({'username': {'$eq': username},
                        })

        ans = list(ans)
        self.__close_db()
        return ans
