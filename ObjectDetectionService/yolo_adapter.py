import torch
from detect import check_requirements, detect, strip_optimizer
from argparse import Namespace


def my_detect(weights='yolov5s.pt', source='data/images', img_size=640, conf_thres=0.25, iou_thres=0.45, device='',
              view_img=False, save_txt=False, save_conf=False, classes=None, agnostic_nms=False, augment=False,
              update=False, project='runs/detect', name='exp', exist_ok=False):
    opt = Namespace(weights=weights, source=source, img_size=img_size, conf_thres=conf_thres, iou_thres=iou_thres,
                    device=device, view_img=view_img, save_txt=save_txt, save_conf=save_conf, classes=classes,
                    agnostic_nms=agnostic_nms, augment=augment, update=update, project=project, name=name,
                    exist_ok=exist_ok)
    print(opt)
    check_requirements()

    with torch.no_grad():
        if opt.update:  # update all models (to fix SourceChangeWarning)
            for opt.weights in ['yolov5s.pt', 'yolov5m.pt', 'yolov5l.pt', 'yolov5x.pt']:
                detect(opt)
                strip_optimizer(opt.weights)
        else:
            detect(opt)


my_detect()
