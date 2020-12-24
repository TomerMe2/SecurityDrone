from socketIO_client import SocketIO
import cv2
import pymongo

def med_mock_teat():
    socketIO = SocketIO('localhost', 5001)
    img = cv2.imread('dune-sand-man-desert.jpg')
    _, img_encoded = cv2.imencode('.jpg', img)
    socketIO.emit('image',data=img_encoded.tostring())
    myclient = pymongo.MongoClient("mongodb://localhost:27017/")
    db = myclient["mydatabase"]
    images = db.images
    for image in images:
        print(type(image))

if __name__ == "__main__":
    med_mock_teat()