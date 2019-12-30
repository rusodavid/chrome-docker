# Base docker image
FROM ubuntu:18.04
LABEL maintainer "Jessie Frazelle <jess@linux.com>"

# Install Chrome
RUN apt-get update && apt-get install -y \
	apt-transport-https \
	ca-certificates \
	curl \
	gnupg \
	hicolor-icon-theme \
	mesa-utils \
	libcanberra-gtk* \ 
	libgl1-mesa-dri \
	libgl1-mesa-glx \
	libpango1.0-0 \
	libpulse0 \
	libv4l-0 \
	fonts-symbola \
	--no-install-recommends

RUN apt-get update && apt-get install -y build-essential \
	binutils \
        kmod \
        dh-make \
        fakeroot \
        build-essential \
        libglvnd-dev \
        pkg-config \
        devscripts \
        lsb-release
RUN apt-get --purge remove -y nvidia*
RUN apt-get install wget


#ADD NVIDIA-DRIVER.run /tmp/NVIDIA-DRIVER.run 
#ADD cuda_10.2.89_440.33.01_linux.run /tmp/cuda_10.2.89_440.33.01_linux.run
#RUN sh /tmp/NVIDIA-DRIVER.run -a -s --no-kernel-module 
#RUN rm -rf /tmp/selfgz7

ARG NVIDIA_DRIVER=NVIDIA-Linux-x86_64-440.44.run
RUN wget http://es.download.nvidia.com/XFree86/Linux-x86_64/440.44/${NVIDIA_DRIVER} --progress=dot:giga -P /tmp
ARG CUDA_DRIVER=cuda_10.2.89_440.33.01_linux.run
RUN wget http://developer.download.nvidia.com/compute/cuda/10.2/Prod/local_installers/${CUDA_DRIVER} --progress=dot:giga -P /tmp

RUN sh /tmp/${NVIDIA_DRIVER} -a -s --no-kernel-module 
RUN sh /tmp/${CUDA_DRIVER} --silent --toolkit

RUN export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64
RUN touch /etc/ld.so.conf.d/cuda.conf  
RUN rm -rf /temp/* 

RUN curl -sSL https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
	&& echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list \
	&& apt-get update && apt-get install -y \
	google-chrome-stable \
	--no-install-recommends \
	&& apt-get purge --auto-remove -y curl \ 
	&& rm -rf /var/lib/apt/lists/*


# Add chrome user
RUN groupadd -r chrome && useradd -r -g chrome -G audio,video chrome \
    && mkdir -p /home/chrome/Downloads \
    && chown -R chrome:chrome /home/chrome

COPY local.conf /etc/fonts/local.conf
#COPY chrome.json /home/chrome/chrome.json

# Run Chrome as non privileged user
USER chrome

# Autorun chrome
ENTRYPOINT [ "google-chrome" ]
CMD [ "--user-data-dir=/data" ]

