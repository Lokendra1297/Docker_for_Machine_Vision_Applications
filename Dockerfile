# Base image with CUDA 12.6.3
FROM nvidia/cuda:12.6.3-base-ubuntu20.04

# Set non-interactive mode for APT
ENV DEBIAN_FRONTEND=noninteractive
ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64:/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH
ENV WORKDIR=/workspace

# Install essential tools, CUDA Toolkit, and dependencies
RUN apt-get update && apt-get install -y \
    wget curl build-essential cmake git software-properties-common gnupg \
    lsb-release cuda-toolkit-12-6 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Install NVIDIA Container Toolkit
RUN distribution=$(. /etc/os-release;echo $ID$VERSION_ID) && \
    curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | apt-key add - && \
    curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | \
    tee /etc/apt/sources.list.d/nvidia-docker.list && \
    apt-get update && apt-get install -y nvidia-container-toolkit \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Configure NVIDIA runtime
RUN mkdir -p /etc/docker && \
    echo '{"runtimes": {"nvidia": {"path": "nvidia-container-runtime", "runtimeArgs": []}}}' > /etc/docker/daemon.json

# Install cuDNN Runtime and Developer Packages
ENV NV_CUDNN_VERSION 9.5.1.17-1
ENV NV_CUDNN_PACKAGE_NAME libcudnn9-cuda-12
ENV NV_CUDNN_PACKAGE libcudnn9-cuda-12=${NV_CUDNN_VERSION}
ENV NV_CUDNN_PACKAGE_DEV libcudnn9-dev-cuda-12=${NV_CUDNN_VERSION}

RUN apt-get update && apt-get install -y --no-install-recommends \
    ${NV_CUDNN_PACKAGE} \
    ${NV_CUDNN_PACKAGE_DEV} \
    && apt-mark hold ${NV_CUDNN_PACKAGE_NAME} \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Install TensorRT and Development Libraries
COPY nv-tensorrt-local-repo-ubuntu2004-10.4.0-cuda-12.6_1.0-1_amd64.deb /tmp/
RUN dpkg -i /tmp/nv-tensorrt-local-repo-ubuntu2004-10.4.0-cuda-12.6_1.0-1_amd64.deb && \
    cp /var/nv-tensorrt-local-repo-ubuntu2004-10.4.0-cuda-12.6/nv-tensorrt-local-A88B7455-keyring.gpg /usr/share/keyrings/ && \
    apt-get update && apt-get install -y \
        libnvinfer10 \
        libnvinfer-dev \
        libnvinfer-plugin10 \
        libnvinfer-headers-dev && \
    apt-mark hold libnvinfer10 libnvinfer-dev libnvinfer-plugin10 && \
    rm -f /tmp/nv-tensorrt-local-repo-ubuntu2004-10.4.0-cuda-12.6_1.0-1_amd64.deb \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Install ROS Noetic
RUN echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/ros1.list && \
    curl -sSL http://packages.ros.org/ros.key | apt-key add - && \
    apt-get update && apt-get install -y \
    ros-noetic-desktop-full \
    ros-noetic-rospy \
    ros-noetic-std-msgs \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Set up ROS environment and persist in bashrc
RUN echo "source /opt/ros/noetic/setup.bash" >> /root/.bashrc && \
    /bin/bash -c "source /root/.bashrc"

# Install TensorRT Python bindings
RUN pip3 install nvidia-pyindex && \
    pip3 install nvidia-tensorrt

# Optional: Add a validation script for runtime checks
COPY validate.sh /usr/local/bin/validate.sh
RUN chmod +x /usr/local/bin/validate.sh

# Set default working directory
WORKDIR $WORKDIR

# Default command: Start a bash shell
CMD ["bash"]
