import pymongo
from threading import Thread
from time import sleep
import med_comm
import json
import io


def run(db):
    col  = db['waypoints']
    waypoints = col.find()
    med_comm.socketio.emit('patrol',json.dumps(waypoints))


class mission_controller:
    def __init__(self):
        myclient = pymongo.MongoClient("mongodb://localhost:27017/")
        self.db = myclient["mydatabase"]

    def update_waypoints(self,waypoints):
        insert_list = []
        col = self.db['waypoints']
        print(waypoints)
        for point in waypoints:
            row = {'latitude': point['latitude'], 'longtitude': point['longtitude']}
            col.insert_one(row)

    def add_thief(self,im):
        #call image detection
        images = db.images
        image_bytes = io.BytesIO()
        im.save(image_bytes, format='JPEG')
        image = {
            'data': image_bytes.getvalue()
        }
        images.insert_one(image)

    def start_patrol(self):
        thread = Thread(target=run, args=db)
        thread.start()
        thread.join()
