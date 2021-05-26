import json
import codecs

import pymongo
from werkzeug.security import generate_password_hash

from config import config

LAT = 32
LON = 34
login_url = '/login'


def make_json_from(image_data, lat=LAT, lon=LON):
    return json.dumps({
        'image': codecs.encode(image_data, 'base64').decode(),
        'lat': lat,
        'lon': lon
    })


def create_test_user_and_delete_prev(username='test', plaintext_password='1234'):
    with pymongo.MongoClient(config['db_url']) as db_client:
        password = generate_password_hash(plaintext_password)

        db = db_client[config['app_db_client_name']]
        col = db[config['users_db_name']]

        col.delete_many({})
        col.insert_one({'username': username, 'password': password})


def get_token(test_app, username='test', plaintext_password='1234'):
    login_response = test_app.post(login_url, data=json.dumps({
        'username': username,
        'password': plaintext_password
    }))

    assert login_response.status_code == 200
    return login_response.json['token']
