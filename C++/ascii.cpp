#include <iostream>
#include <fstream>
#include <vector>
#include "opencv2/opencv.hpp"

int main(int argc, char** argv) {
    // Check if an image file is provided
    if (argc != 2) {
        std::cout << "Usage: " << argv[0] << " image_file" << std::endl;
        return 1;
    }

    // Load the image
    cv::Mat image = cv::imread(argv[1], cv::IMREAD_GRAYSCALE);
    if (!image.data) {
        std::cout << "Could not open or find the image" << std::endl;
        return 1;
    }

    // Resize the image to a smaller size
    cv::resize(image, image, cv::Size(), 0.3, 0.3);

    // Create an ASCII art string
    std::string ascii_art = "";
    std::vector<std::string> ascii_chars = {"@", "#", "S", "%", "?", "*", "+", ";", ":", " "};
    for (int i = 0; i < image.rows; i++) {
        for (int j = 0; j < image.cols; j++) {
            int pixel_value = image.at<uchar>(i, j);
            int char_index = pixel_value / 25;
            ascii_art += ascii_chars[char_index];
        }
        ascii_art += "\n";
    }

    // Print the ASCII art
    std::cout << ascii_art << std::endl;

    return 0;
}
