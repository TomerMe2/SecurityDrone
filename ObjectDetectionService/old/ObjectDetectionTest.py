import ObjectDetection


def test_person_pos(expected, path):
    ans = ObjectDetection.person_pos(path)
    assert len(ans) == expected
    for lst in ans:
        for num in lst:
            assert num > 0


def test_num_of_persons(expected, path):
    ans = ObjectDetection.num_of_persons(path)
    assert ans == expected


test_num_of_persons(4, 'D:/School/Project/SecurityDrone/ObjectDetectionService/yolov5/data/images/bus.jpg')
test_person_pos(2, 'D:/School/Project/SecurityDrone/ObjectDetectionService/yolov5/data/images/zidane.jpg')
test_num_of_persons(0, 'D:/School/Project/SecurityDrone/ObjectDetectionService/yolov5/data/images/index.jpg')
test_num_of_persons(0, 'D:/School/Project/SecurityDrone/ObjectDetectionService/yolov5/data/images/bus_no_pepole.jpg')