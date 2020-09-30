package com.example;

import org.opencv.core.Core;
import org.opencv.core.Mat;
import org.opencv.videoio.VideoCapture;

class Main {
    static {
        System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
    }

    public static void main(String[] args) {
        VideoCapture cap = new VideoCapture(2);

        if (!cap.isOpened()) {
            System.exit(-1);
        }

        // Matrix for storing image
        Mat image = new Mat();
        // Frame for displaying image
        MyFrame frame = new MyFrame();
        frame.setVisible(true);

        // Main loop
        while (true) {
            // Read current camera frame into matrix
            cap.read(image);
            // Render frame if the camera is still acquiring images
            if (!image.empty()) {
                frame.render(image);
            } else {
                System.out.println("No captured frame -- camera disconnected");
            }
        }
    }
}
