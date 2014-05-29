FROM ubuntu:14.04 
RUN dpkg --add-architecture i386
RUN apt update
RUN apt install -y git unzip curl
RUN apt install -y libc6:i386
RUN apt install -y x11vnc xvfb
RUN apt install -y inotify-tools git


# squeak display driver
RUN apt install -y libgl1-mesa-glx:i386 libxext6:i386 libsm6:i386 libice6:i386 libx11-6:i386

#squeak 4.4
RUN apt install -y libglu1-mesa:i386 libxrender1:i386 libfreetype6:i386

# setup VNC
RUN mkdir /.vnc
RUN x11vnc -storepasswd 1234 ~/.vnc/passwd

ENV VERSION 4.5
ADD http://ftp.squeak.org/$VERSION/Squeak-$VERSION-All-in-One.zip Squeak.zip
RUN unzip Squeak.zip

ADD images/ images/


ADD . /

RUN git config --global user.name TestUsername
RUN git config --global user.email TestUser@example.com

EXPOSE 5900
CMD Xvfb -screen 0 1024x768x16 -ac & sleep 5 ; x11vnc -forever -usepw -display :0 & ./wait_monticello_commit.sh & DISPLAY=:0 ./Squeak-$VERSION-All-in-One.app/Contents/Linux-i686/bin/squeak  -vm-sound-null ./images/Squeak*.image /install.st
