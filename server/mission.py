import pymongo
from threading import Thread
from time import sleep
import json
import io
import base64

class mission_controller:
    def __init__(self):
        #database will be created only when invoked for the first time
        myclient = pymongo.MongoClient("mongodb://localhost:27017/")
        self.db = myclient["mydatabase"]

    def update_waypoints(self,waypoints):
        insert_list = []
        col = self.db['waypoints']
        col.delete_many({})
        for point in waypoints:
            row = {'latitude': point['latitude'], 'longtitude': point['longtitude']}
            insert_list.append(row)
        col.insert_many(insert_list)

    def add_thief(self,img):
        #call image detection
        col = self.db['images']
        img_byte_arr = io.BytesIO()
        img.save(img_byte_arr, format='JPEG')
        image = {
            'data': img_byte_arr.getvalue()
        }
        col.insert_one(image)

    def start_patrol(self):
        col = self.db['waypoints']
        list =[]
        waypoints = col.find()
        for point in waypoints:
            list.append(point)

