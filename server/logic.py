from config import config
import data_access


class logic_controller:
    def __init__(self):
        self.access = data_access.data_controller()

    def update_waypoints(self,waypoints):
        self.access.update_waypoints(waypoints)

    def close_db(self):
        self.access.close_db()

    def get_waypoints(self):
        return self.access.get_waypoints()

    def convet_im(self,im_json):
        return True

    def check_image(self,im_json):
        return False

    def add_thief(self,image):
        return True