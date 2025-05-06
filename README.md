# Create a camera node

Here you can find a guide on how to get a ROS2 Jazzy camera package on a Raspberry Pi 5 running Ubuntu 24.04

Index:
- [Build `libcamera`](build-`libcamera`)
- [Build `rpicam-apps`](build-`rpicam-apps`)
- [Install the `camera_ros` package](install-the-`camera-ros`-package)
- [Build the ROS packages](build-the-ros-packages)
- [Start the `camera_ros` package](start-the-`camera-ros`-package)

---
> [!WARNING]
>`libcamera` does not yet have a stable binary interface. Always build `rpicam-apps` after you have built libcamera.

Before you start create a ROS2 workspace

```bash
mkdir -p ~/ros2_ws/src
```

---

## Build `libcamera`

1. Enter the `src` folder inside the ROS2 workspace:
   ```
   cd ~/ros2_ws/src
   ```

2. First, install the following libcamera dependencies:
   ```bash
   sudo apt install -y libboost-dev
   sudo apt install -y libgnutls28-dev openssl libtiff5-dev pybind11-dev
   sudo apt install -y qtbase5-dev libqt5core5a libqt5gui5 libqt5widgets5
   sudo apt install -y meson cmake
   sudo apt install -y python3-yaml python3-ply
   sudo apt install -y libglib2.0-dev libgstreamer-plugins-base1.0-dev
   ```

3. Download a local copy of Raspberry Pi’s fork of libcamera from GitHub:
   ```bash
   git clone https://github.com/raspberrypi/libcamera.git
   ```
   
4. Navigate into the root directory of the repository:
   ```bash
   cd libcamera
   ```
   
5. Next, run meson to configure the build environment:
   ```bash
   meson setup build --buildtype=release -Dpipelines=rpi/vc4,rpi/pisp -Dipas=rpi/vc4,rpi/pisp -Dv4l2=true -Dgstreamer=enabled -Dtest=false -Dlc-compliance=disabled -Dcam=disabled -Dqcam=disabled -Ddocumentation=disabled -Dpycamera=enabled
   ```
   
6. Now, you can build libcamera with ninja:
   ```bash
   ninja -C build
   ```
   
7. Finally, run the following command to install your freshly-built libcamera binary:
   ```bash
   sudo ninja -C build install
   ```

## Build `rpicam-apps`

1. Enter the `src` folder inside the ROS2 workspace:
   ```
   cd ~/ros2_ws/src
   ```

2. First fetch the necessary dependencies for rpicam-apps:
   ```bash
   sudo apt install -y cmake libboost-program-options-dev libdrm-dev libexif-dev
   sudo apt install -y meson ninja-build
   ```

3. Download a local copy of Raspberry Pi’s `rpicam-apps` GitHub repository:
   ```bash
   git clone https://github.com/raspberrypi/rpicam-apps.git
   ```

4. Navigate into the root directory of the repository:
   ```bash
   cd rpicam-apps
   ```

5. Install some extra packages
   ```bash
   sudo apt install libavdevice*
   sudo apt install libepoxy-dev
   ```
   
6. For desktop-based operating systems (like Ubuntu 24.04), configure the rpicam-apps build with the following meson command:
   ```bash
   meson setup build -Denable_libav=enabled -Denable_drm=enabled -Denable_egl=enabled -Denable_qt=enabled -Denable_opencv=enabled -Denable_tflite=disabled -Denable_hailo=disabled
   ```
   
7. You can now build rpicam-apps with the following command:
   ```bash
   meson compile -C build
   ```
   
8. Finally, run the following command to install your freshly-built `rpicam-apps` binary:
   ```bash
   sudo meson install -C build
   ```
    
9. The command above should automatically update the ldconfig cache. If you have trouble accessing your new `rpicam-apps` build, run the following command to update the cache:
   ```bash
   sudo ldconfig
   ```

10. Run the following command to check that your device uses the new binary:
    ```bash
    rpicam-still --version
    ```

## Install the `camera_ros` package

1. Enter the `src` folder inside the ROS2 workspace:
   ```
   cd ~/ros2_ws/src
   ```

2. Then clone the `camera_ros` GitHub repository:
   ```bash
   git clone https://github.com/christianrauch/camera_ros.git
   ```

## Build the ROS packages

1. Enter the workspace folder:
   ```
   cd ~/ros2_ws
   ```

2. Check for missing dependencies before building:
   ```bash
   rosdep install -i --from-path src --rosdistro jazzy -y
   ```

3. Build the packages:
   ```bash
   colcon build
   ```

## Start the `camera_ros` package
1. Open a new terminal and source the setup files:
   ```bash
   source ~/ros2_ws/install/setup.bash
   ```

2. Start the `camera_ros` package:
   ```bash
   ros2 launch camera_ros camera.launch.py
   ```



















