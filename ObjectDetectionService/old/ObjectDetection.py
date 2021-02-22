import os
import shutil

PERSON_LABEL = '0'
MY_COUNT = 0
YOLO_COMMAND = 'D:/School/Project/yolov5/detect.py'


def detect_pos(img):
    img.save('./images/Test.jpg')
    ans = person_pos('./images/Test.jpg')
    os.remove('./images/Test.jpg')
    return ans

def detect_num(img):
    img.save('./images/Test.jpg')
    ans = num_of_persons('./images/Test.jpg')
    os.remove('./images/Test.jpg')
    return ans


def num_of_persons(img_path, delete_old=True):
    global MY_COUNT
    if MY_COUNT == 0:
        if delete_old:
            try:
                shutil.rmtree('./runs')
            except:
                pass
        suffix = ''
        MY_COUNT = 1
    else:
        suffix = str(MY_COUNT)
    MY_COUNT += 1

    num_of_man = 0
    my_command = 'python ' + YOLO_COMMAND + ' --weights yolov5s.pt --source ' + img_path + ' --save-txt'
    os.system(my_command)
    image_name = img_path.split('/')[-1]
    image_name = image_name.split('.')[0]
    try:
        file = open('./runs/detect/exp' + suffix + '/labels/' + image_name + '.txt', 'r')
        line = file.readline()
        while line:
            word_arr = line.split(' ')
            if word_arr[0] == PERSON_LABEL:
                num_of_man += 1
            line = file.readline()
    except Exception as e:
        return 0
    return num_of_man


def person_pos(img_path, delete_old=True):
    # return arr of human positions in picture
    global MY_COUNT
    if MY_COUNT == 0:
        if delete_old:
            try:
                shutil.rmtree('./runs')
            except:
                pass
        suffix = ''
        MY_COUNT = 1
    else:
        suffix = str(MY_COUNT)
    MY_COUNT += 1

    pos_arr = []
    my_command = 'python ' + YOLO_COMMAND + ' --weights yolov5s.pt --source ' + img_path + ' --save-txt'
    os.system(my_command)
    image_name = img_path.split('/')[-1]
    image_name = image_name.split('.')[0]
    try:
        file = open('./runs/detect/exp' + suffix + '/labels/' + image_name + '.txt', 'r')
        line = file.readline()
        while line:
            word_arr = line.split(' ', 1)

            if word_arr[0] == PERSON_LABEL:
                pos_arr.append(str_to_int(word_arr[1][1:len(word_arr[1]) - 1]))
            line = file.readline()
    except Exception as e:
        return 0
    return pos_arr


def str_to_int(str):
    words = str.split(' ')
    int_lst = []
    for word in words:
        try:
            int_lst.append(float(word))
        except Exception as e:
            continue
    return int_lst


