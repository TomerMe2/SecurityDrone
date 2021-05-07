import pymongo
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

        insert_lst = [{'latitude': point['latitude'], 'longitude': point['longitude']} for point in waypoints]
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

    def get_waypoints(self):
        """
        :return: the waypoints that currently stored in the db
        """
        self.__connect_to_db()

        col = self.db[config['waypoints_db_name']]
        waypoints = list(col.find())

        self.__close_db()
        return waypoints

    def get_images_of_thieves(self, date_from, date_until, index_from, index_until):
        self.__connect_to_db()
        col = self.db[config['thief_images_db_name']]

        query_params = {}
        if date_from is not None:
            query_params['$gte'] = date_from
        if date_until is not None:
            query_params['$lte'] = date_until

        if query_params == {}:
            return col.find({}, {'_id': 0}).sort('date', -1).skip(index_from).limit(index_until - index_from)
        else:
            return col.find({'date': query_params}, {'_id': 0}).sort('date', -1).\
                skip(index_from).limit(index_until - index_from)

