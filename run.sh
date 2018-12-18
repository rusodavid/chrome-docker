# Run Chrome in a container
xhost local:root
docker run --rm -it --net host --cpuset-cpus 0 --memory 512mb -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=unix$DISPLAY -v /data/chrome/Downloads:/home/chrome/Downloads -v /data/chrome/data:/data --device /dev/snd --device /dev/dri -v /dev/shm:/dev/shm --security-opt seccomp=/data/chrome/chrome.json --name chrome chrome --no-sandbox

# You will want the custom seccomp profile:
#       wget https://raw.githubusercontent.com/jfrazelle/dotfiles/master/etc/docker/seccomp/chrome.json -O ~/chrome.json
#-v /data/chrome/.config/google-chrome/:/home/chrome/.config/google-chrome
