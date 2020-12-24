from flask import Flask,request
import json
import mission


app = Flask(__name__)

@app.route('/update_waypoints', methods=('POST',))
def up_waypoints():
    if request.method == 'POST':
        waypoints = request.get_json(force = True)
        m = mission.mission_controller()
        m.update_waypoints(waypoints)
        return 'true'

@app.route('/patrol', methods=('POST',))
def send_patrol():
    if request.method == 'POST':
        m = mission.mission_controller()
        m.update_waypoints(waypoints)

if __name__ == "__main__":
    app.run(port=5000)
