# Docker ML/DL Development Container

This repository contains the docker script for a full development Tensorflow v2.7 GPU environment. 

Perks:
- Debian OS - Ubuntu 18.04
- CUDA/Nvidia drivers installed
- Tensorflow 2.7.0
- VNC server
- JupyterLab
- VScode
- Tmux
- SSH/SFTP with public/private key pair 
(Create public/private key pairs and rename public key file as id_ed.pub in ./ssh directory)

Ports exposed:
- 8888 - JupyterLab
- 5901 - VNC
- 6006 - Tensorboard
- 22 - SSH/SFTP
