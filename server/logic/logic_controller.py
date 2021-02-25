import cv2
import numpy as np
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

    def process_image(self, image_str, date, object_detector):
        arr = np.fromstring(image_str, np.uint8)
        # decode image
        img = cv2.imdecode(arr, cv2.IMREAD_COLOR)

        is_thief = object_detector.predict(img)

        if is_thief:
            data_controller = DataController()
            return data_controller.save_thief_img(image_str, date)
        else:
            return True
