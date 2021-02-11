from socketIO_client import SocketIO
import requests
import cv2
import pymongo
from PIL import Image
import io

addr = 'http://localhost:5001'
test_url = addr + '/image'

def med_mock_teat():
    img = cv2.imread('dune-sand-man-desert.jpg')
    _, img_encoded = cv2.imencode('.jpg', img)
    requests.post(test_url, data=img_encoded.tobytes())
    myclient = pymongo.MongoClient("mongodb://localhost:27017/")
    db = myclient["mydatabase"]
    col = db['images']
    image = col.find_one()

if __name__ == "__main__":
    med_mock_teat()