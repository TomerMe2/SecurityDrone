import cv2
import numpy as np
from werkzeug.security import check_password_hash
from datetime import datetime
from data_access.data_controller import DataController
from data_objects.missions import Mission, MissionType, StartReasonType, EndReasonType


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

    def update_home_waypoint(self, lat, lon):
        data_controller = DataController()
        return data_controller.update_home_waypoint(lat, lon)

    def get_home_waypoint(self):
        data_controller = DataController()
        return data_controller.get_home_waypoint()

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
            has_saved_image = data_controller.save_thief_img(image_str, date, lat, lon)

            if not has_saved_image:
                return is_thief, False

            time = datetime.now()
            new_sub_mission = Mission(mission_type=MissionType.TRACK, sub_missions=[],
                                      start_reason=StartReasonType.FOUND_THIEF,
                                      end_reason=None,
                                      start_time=time,
                                      end_time=None)

            open_mission = data_controller.get_open_mission()
            if open_mission is None or len(open_mission.sub_missions) > 0:
                return is_thief, False

            # TODO: UNDO TRACKING IF NOT FINDING THIEF FOR A "LONG" TIME
            if open_mission.sub_missions[-1].mission_type != MissionType.TRACK:
                has_saved_mission = data_controller.add_sub_mission_to_open_mission(new_sub_mission,
                                                                                    EndReasonType.FOUND_THIEF,
                                                                                    time)
                return is_thief, has_saved_mission

            return is_thief, True

        else:
            return is_thief, True

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
