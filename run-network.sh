# Run Chrome in a container
xhost local:root
docker run -it --net test --ip 192.168.2.10 --dns 192.168.2.11 --cpuset-cpus 0 -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=unix$DISPLAY -v /var/run/dbus/system_bus_socket:/var/run/dbus/system_bus_socket -v /data/chrome/Downloads:/home/chrome/Downloads -v /data/chrome/data:/data --device /dev/snd --device /dev/dri -v /dev/shm:/dev/shm --security-opt seccomp=/data/chrome/chrome.json --name chrome-network chrome --no-sandbox

#--env HTTP_PROXY="http://localhost:3128" --env HTTPS_PROXY="http://localhost:3128"
