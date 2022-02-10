
FROM tensorflow/tensorflow:2.7.0-gpu-jupyter

WORKDIR "/"

ENV DEBIAN_FRONTEND noninteractive
ENV USER root

RUN apt-get update
RUN apt-get install -y python3-pip python3-requests build-essential python3-dev cython3 python3-setuptools \
                       python3-wheel python3-pytest python3-blosc python3-brotli python3-snappy python3-lz4 python3-venv \
                       libgl1-mesa-glx libgtk2.0-dev python3-tk python3-xdg \
                       software-properties-common tcl 

RUN apt-get install -y openssh-server

RUN echo 'root:sftp' | chpasswd

RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

ADD ./ssh/sshd_config /etc/ssh/sshd_config
ADD ./ssh/id_ed.pub /root/.ssh/
RUN cat /root/.ssh/id_ed.pub >> /root/.ssh/authorized_keys

# Install LXDE and VNC server.
RUN apt-get update && \
    apt-get install -y --no-install-recommends ubuntu-desktop && \
    apt-get install -y gnome-panel gnome-settings-daemon metacity nautilus gnome-terminal && \
    apt-get install -y tightvncserver && \
    mkdir /root/.vnc

ADD ./vnc/xstartup /root/.vnc/xstartup
RUN chmod +x /root/.vnc/xstartup
RUN chmod +x /etc/X11/xinit/xinitrc

#install useful tools
RUN apt-get update
RUN apt-get install -y apt-utils
RUN apt-get install -y nano
RUN apt-get install -y libcupti-dev
RUN apt-get install -y tmux
ADD ./tmux.conf /etc/tmux.conf
RUN apt-get install -y iproute2
RUN apt-get install -y firefox
RUN apt-get install -y git 
RUN apt-get install -y cifs-utils
RUN apt-get install -y htop
RUN apt-get install -y gedit
RUN apt-get install -y terminator
RUN apt-get install -y snapd
RUN apt-get install eog

WORKDIR "/"
ADD requirements.txt /requirements.txt
RUN /usr/bin/python3 -m pip install --upgrade pip
RUN python3 -m pip install -r /requirements.txt

#setup jupyter notebook
ADD jupyter_notebook_config.py /root/.jupyter/

#Expose ports
EXPOSE 8888
EXPOSE 5901
EXPOSE 6006
EXPOSE 22

#Add a startup script to start Jupyter and make it running
ADD ./startup.sh /startup.sh

ENTRYPOINT ["/bin/bash","./startup.sh"]
