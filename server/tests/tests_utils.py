import json
import codecs


LAT = 32
LON = 34


def make_json_from(image_data, lat=LAT, lon=LON):
    return json.dumps({
        'image': codecs.encode(image_data, 'base64').decode(),
        'lat': lat,
        'lon': lon
    })