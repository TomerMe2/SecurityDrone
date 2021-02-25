ECHO OFF
python -m venv server_venv
server_venv\Scripts\pip.exe install -r requirements.txt
server_venv\Scripts\pip.exe install torch==1.7.1+cpu torchvision==0.8.2+cpu -f https://download.pytorch.org/whl/torch_stable.html
server_venv\Scripts\pip.exe install yolov5 --no-deps