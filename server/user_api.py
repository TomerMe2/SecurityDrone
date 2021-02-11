from flask import Flask, request
import mission
import json
from config import config


app = Flask(__name__)


@app.route('/update_waypoints', methods=('POST',))
def update_waypoints():
    if request.method == 'POST':
        waypoints = request.get_json(force=True)
        m = mission.MissionController()
        m.update_waypoints(waypoints)
        m.close_db()
        return 'true'


@app.route('/patrol', methods=('POST',))
def send_patrol():
    if request.method == 'POST':
        m = mission.MissionController()
        m.start_patrol()
    return ''


if __name__ == "__main__":
    app.run(port=config['user_api_port'])
