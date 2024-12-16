#!/bin/bash

# 1. Testing CUDA: Detecting GPU availability
echo "Testing CUDA..."
nvcc --version

echo "Testing GPU availability with nvidia-smi..."
nvidia-smi || echo "No NVIDIA GPUs found or failed to access the GPU."

# 2. Testing TensorRT: Running a simple inference (example using TensorRT)
echo "Testing TensorRT inference..."

# Example: Assuming the TensorRT model and libraries are installed and ready for use
# Create a simple Python script for inference (this could be replaced with actual inference code)

echo "import tensorrt as trt" > /tmp/test_inference.py
echo "print('TensorRT version:', trt.__version__)" >> /tmp/test_inference.py

# Run the simple Python inference script
python3 /tmp/test_inference.py

# Clean up temporary file
rm /tmp/test_inference.py

# 3. Testing ROS: Publish and subscribe to a topic

# Start ROS core in the background
echo "Starting ROS core..."
source /opt/ros/noetic/setup.bash && roscore &
sleep 5  # Wait for the ROS core to start

# Create a temporary Python script to act as a ROS publisher and subscriber
echo "Creating ROS publisher and subscriber..."

# Publisher script
echo "import rospy
from std_msgs.msg import String

def publisher():
    pub = rospy.Publisher('chatter', String, queue_size=10)
    rospy.init_node('talker', anonymous=True)
    rate = rospy.Rate(1)  # 1Hz
    while not rospy.is_shutdown():
        hello_str = 'Hello ROS1 from Docker!'
        rospy.loginfo(hello_str)
        pub.publish(hello_str)
        rate.sleep()

if __name__ == '__main__':
    try:
        publisher()
    except rospy.ROSInterruptException:
        pass" > /tmp/ros_publisher.py

# Subscriber script
echo "import rospy
from std_msgs.msg import String

def callback(data):
    rospy.loginfo('I heard %s', data.data)

def subscriber():
    rospy.init_node('listener', anonymous=True)
    rospy.Subscriber('chatter', String, callback)
    rospy.spin()

if __name__ == '__main__':
    try:
        subscriber()
    except rospy.ROSInterruptException:
        pass" > /tmp/ros_subscriber.py

# Run publisher and subscriber
echo "Running ROS publisher and subscriber..."
python3 /tmp/ros_publisher.py &  # Run publisher in background
sleep 2  # Allow publisher to start

# Run subscriber
python3 /tmp/ros_subscriber.py

# Clean up ROS scripts
rm /tmp/ros_publisher.py /tmp/ros_subscriber.py

echo "ROS Test Completed."

# End the script
echo "Validation script finished."
