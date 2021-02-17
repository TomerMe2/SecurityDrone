import pymongo
from config import config
import io
import matplotlib.pyplot as plt
import matplotlib.image as mpimg



class data_controller:
    def __init__(self):
        self.db_client = pymongo.MongoClient(config['db_url'])
        self.db = self.db_client[config['app_db_client_name']]

    def close_db(self):
        self.db_client.close()

    def update_waypoints(self, waypoints):
        col = self.db[config['waypoints_db_name']]
        col.delete_many({})
        insert_lst = [{'latitude': point['latitude'], 'longtitude': point['longtitude']} for point in waypoints]
        col.insert_many(insert_lst)

    def add_thief(self, img):
        # call image detection
        col = self.db['images']
        img_byte_arr = io.BytesIO()
        img.save(img_byte_arr, format='JPEG')
        image = {
            'data': img_byte_arr.getvalue()
        }
        imgplot = plt.imshow(image)
        plt.show()
        col.insert_one(image)

    def get_waypoints(self):
        col = self.db['waypoints']
        waypoints = list(col.find())
        return waypoints

