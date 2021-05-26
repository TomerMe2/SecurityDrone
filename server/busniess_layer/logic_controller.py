import cv2
import numpy as np
from werkzeug.security import check_password_hash

from data_access.data_controller import DataController


class LogicController:
    """
    This class meant to be initiated many times in the lifetime of the program.
    Each request that has logic in it should initiate a logic controller.
    """

    def update_waypoints(self, waypoints):
        if len(waypoints) < 2:
            return False

        data_controller = DataController()
        return data_controller.update_waypoints(waypoints)

    def get_waypoints(self):
        data_controller = DataController()
        return data_controller.get_waypoints()

    def process_image(self, image_str, date, lat, lon, object_detector):
        """
        :param object_detector: yolov5 adaptor instance
        :return: 2-tuple, first cell is is_there_thief, second cell is true iff the code run successfully
        (it will be false if an exception was raised)
        """
        arr = np.fromstring(image_str, np.uint8)
        # decode image
        img = cv2.imdecode(arr, cv2.IMREAD_COLOR)

        is_thief = object_detector.predict(img)

        if is_thief:
            data_controller = DataController()
            return True, data_controller.save_thief_img(image_str, date, lat, lon)
        else:
            return False, True

    def get_images_of_thieves(self, date_from, date_until, index_from, index_until):
        data_controller = DataController()

        if index_from is None:
            index_from = 0
        if index_until is None:
            index_until = 20

        return list(data_controller.get_images_of_thieves(date_from, date_until, index_from, index_until))

    def can_login(self, username, plaintext_password):
        data_controller = DataController()

        candidates = data_controller.get_user(username)
        if len(candidates) == 1:
            if check_password_hash(candidates[0]['password'], plaintext_password):
                return True
        return False

    def is_username_exists(self, username):
        data_controller = DataController()

        candidates = data_controller.get_user(username)
        if len(list(candidates)) == 1:
            return True
        return False
