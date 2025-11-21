FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential cmake git pkg-config curl ca-certificates \
    libgtk-3-dev libavcodec-dev libavformat-dev libswscale-dev libv4l-dev \
    libxvidcore-dev libx264-dev libjpeg-dev libpng-dev libtiff-dev libopenexr-dev \
    libtbb-dev libeigen3-dev libatlas-base-dev gfortran \
    unzip wget && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /opt
RUN git clone --branch 4.11.0 --depth 1 https://github.com/opencv/opencv.git && \
    git clone --branch 4.11.0 --depth 1 https://github.com/opencv/opencv_contrib.git

WORKDIR /opt/opencv/build
RUN cmake -D CMAKE_BUILD_TYPE=Release \
          -D CMAKE_INSTALL_PREFIX=/usr/local \
          -D OPENCV_EXTRA_MODULES_PATH=/opt/opencv_contrib/modules \
          -D OPENCV_GENERATE_PKGCONFIG=ON \
          -D BUILD_EXAMPLES=OFF \
          -D BUILD_TESTS=OFF \
          -D BUILD_DOCS=OFF \
          -D BUILD_opencv_python3=OFF \
	  -D BUILD_opencv_java=OFF \
          .. 
RUN make -j$(nproc) && make install && ldconfig

