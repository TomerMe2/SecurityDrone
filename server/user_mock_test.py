import requests
import json
import pymongo

addr = 'http://localhost:5000'
test_url = addr + '/update_waypoints'

def update_waypoint_test():
    waypoint1 = {'latitude':29.36,'longtitude':30.55}
    waypoint2 = {'latitude': 33.36, 'longtitude': 31.55}
    waypoints = [waypoint1,waypoint2]
    data = json.dumps(waypoints)
    response = requests.post(test_url, data=data)
    if response:
        myclient = pymongo.MongoClient("mongodb://localhost:27017/")
        db = myclient["mydatabase"]
        col = db['waypoints']
        waypoints_db = col.find()
        for i,point in enumerate(waypoints):
            if i>1 :
                return False
            if point is not waypoint1 and point is not waypoint2:
                return False
    else:
        return False
    return True

if __name__ == '__main__':
    print(update_waypoint_test())
