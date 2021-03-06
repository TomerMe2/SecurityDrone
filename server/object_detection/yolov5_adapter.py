from yolov5 import YOLOv5
from PIL import Image
from config import config


class YoloAdapter:
    def __init__(self):
        self.PREDICTION_THRESHOLD = 0.45
        self.HUMAN_INDEX = 0
        model_path = config['yolov5_weights']  # it automatically downloads yolov5s model to given path
        device = "cpu"  # or "cuda"
        self.yolo_model = YOLOv5(model_path, device)

    def predict(self, cv2_image):
        """
        :param cv2_image: image in the format of cv2
        :return: true iff yolov5 thought that there's a person involved
        """
        pil_img = Image.fromarray(cv2_image)
        results = self.yolo_model.predict(pil_img)
        # results.pred[0] is a 2d tensor, number of rows are the number of predictions
        # each tensor is a 6-tuple:
        # 0 - 3 (included) are the bounding box
        # 4 is the certainty of the prediction
        # 5 is the index of the object in results.names
        # note that person's index is 0
        for pred in results.pred[0]:
            if pred[-1] == 0 and pred[-2] > self.PREDICTION_THRESHOLD:
                return True

        return False
