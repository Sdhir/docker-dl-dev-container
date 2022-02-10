#!/bin/bash
chmod 600 /root/.vnc/passwd
service ssh start &
vncserver &
jupyter nbextension enable --py widgetsnbextension  &
jupyter lab --ip 0.0.0.0 --port 8888 --allow-root &
sleep infinity