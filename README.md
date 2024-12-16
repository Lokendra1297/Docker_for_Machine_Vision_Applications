# Docker_for_Machine_Vision_Applications

This repository provides a Docker image with the necessary setup for CUDA 12.6.3, TensorRT, cuDNN, and ROS Noetic. The image is designed to work with GPU-accelerated workloads and includes essential tools for machine learning, robotics, and deep learning inference.

## Table of Contents
- Overview
- Prerequisites
- Docker Setup
- Using the Docker Image
- CUDA
- TensorRT
- cuDNN
- ROS1
- Validation Script
- Testing

## Overview

This Docker image is built on top of the nvidia/cuda:12.6.3-base-ubuntu20.04 image and includes:

- CUDA 12.6.3: For GPU acceleration.
- TensorRT: For optimized deep learning inference.
- cuDNN 9.5.1: NVIDIA's GPU-accelerated library for deep neural networks.
- ROS Noetic: For robotics applications.
- Python: Python 3 and essential dependencies for TensorRT, cuDNN, and ROS Python bindings.

## Prerequisites
To use this Docker image, you must have the following:

- Docker installed on your system.
- NVIDIA GPU and the Nvidia-docker runtime installed for GPU support.
- NVIDIA drivers installed for your GPU.
- CUDA toolkit, cuDNN, and TensorRT libraries installed in your environment (this image includes all of these).
- ROS Noetic dependencies are included in the image.

## Docker Setup

1. Build the Docker image: Clone the repository or create your own Dockerfile with the setup provided and build the Docker image.
   ##### docker build -t <YOUR IMAGE NAME> .

2. Run the Docker container: To run the image with GPU support, use the following command:
   ##### docker run --gpus all -it <YOUR IMAGE NAME> bash
   ##### docker run -it <YOUR IMAGE NAME> bash

3. Access the container: Once the container is running, you will be inside the /workspace directory where you can execute your tasks or load your models.

## Using the Docker Image
After running the container, you can start using CUDA, TensorRT, cuDNN, and ROS as follows:

### CUDA
You can check the CUDA version and GPU availability using the following commands:
   ##### nvcc --version  ######Display the CUDA version
   ##### nvidia-smi      ######Show NVIDIA GPU status and usage

### TensorRT
To test TensorRT, a simple Python script is provided that prints the TensorRT version:
   ##### python3 -c "import tensorrt as trt; print('TensorRT version:', trt.__version__)"

### cuDNN
To verify that cuDNN is installed correctly, you can check the cuDNN version using the following Python script:
   ##### python3 -c "import ctypes; libcudnn = ctypes.CDLL('libcudnn.so'); print('cuDNN version:', libcudnn.cudnnGetVersion())"
This will print the installed cuDNN version, ensuring it's properly configured for your deep learning models.

### ROS1
The Docker image comes with ROS Noetic pre-installed. To test ROS1, you can run the following steps:
Start **roscore** in the background:
   ##### roscore &


## Validation Script
The repository also includes a validate.sh script to test the installation of CUDA, TensorRT, cuDNN, and ROS. It performs the following checks:

- CUDA: Verifies that nvcc is available and checks GPU status using nvidia-smi.
- TensorRT: Runs a simple Python script to check if TensorRT is correctly installed.
- cuDNN: Checks the cuDNN version using a Python script.
- ROS1: Starts roscore and runs both a publisher and a subscriber to ensure that ROS communication is working.

You can run the validation script with:
   ##### /usr/local/bin/validate.sh

## Testing
After building and running the Docker container, you can verify everything is working by running the validation script and checking the results of CUDA, TensorRT, cuDNN, and ROS1.
