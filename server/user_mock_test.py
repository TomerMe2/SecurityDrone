import requests
import json
import pymongo

addr = 'http://localhost:5000'
test_url = addr + '/update_waypoints'

def update_waypoint_test1():
    waypoint1 = {'latitude':29.36,'longtitude':30.55}
    waypoint2 = {'latitude': 33.36, 'longtitude': 31.55}
    waypoints = [waypoint1,waypoint2]
    data = json.dumps(waypoints)
    response = requests.post(test_url, data=data)
    if response.text == 'true':
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

def update_waypoint_test2():
    waypoint1 = {'latitude':29.36,'longtitude':30.55}
    waypoint2 = {'latitude': 33.36, 'longtitude': 31.55}
    waypoint3 = {'latitude': 41.36, 'longtitude': 14.55}
    waypoint4 = {'latitude': 39.11, 'longtitude': 25.25}
    waypoints = [waypoint2,waypoint3,waypoint4]
    data = json.dumps(waypoints)
    response = requests.post(test_url, data=data)
    if response.text == 'true':
        myclient = pymongo.MongoClient("mongodb://localhost:27017/")
        db = myclient["mydatabase"]
        col = db['waypoints']
        waypoints_db = col.find()
        for i,point in enumerate(waypoints):
            if i>2 :
                return False
            if point is not waypoint2 and point is not waypoint3 and point is not waypoint4:
                return False
            if point is waypoint1:
                return False
    else:
        return False
    return True

if __name__ == '__main__':
    print('test1')
    if update_waypoint_test1():
        print('pass')
    else:
        print('fail')
    print('test2')
    if update_waypoint_test2():
        print('pass')
    else:
        print('fail')
