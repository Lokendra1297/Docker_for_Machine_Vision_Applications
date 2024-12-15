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

CUDA 12.6.3: For GPU acceleration.
TensorRT: For optimized deep learning inference.
cuDNN 9.5.1: NVIDIA's GPU-accelerated library for deep neural networks.
ROS Noetic: For robotics applications.
Python: Python 3 and essential dependencies for TensorRT, cuDNN, and ROS Python bindings.
