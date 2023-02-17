#include <iostream>
#include <fstream>
#include <string>
#include <regex>
#include <algorithm>
#include <opencv2/opencv.hpp>
#include <opencv2/imgproc.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/videoio.hpp>
#include <opencv2/core/types.hpp>
#include <opencv2/core/utility.hpp>

using namespace std;
using namespace cv;

vector<string> sorted_alphanumeric(vector<string> data) {
    auto convert = [](string text) -> auto {
        if (regex_match(text, regex("\\d+"))) {
            return stoi(text);
        }
        return text;
    };
    auto alphanum_key = [&](string key) -> auto {
        vector<decltype(convert(""))> parts;
        sregex_token_iterator iter(key.begin(), key.end(), regex("(\\d+)|([^\\d]+)"), {-1, 0});
        sregex_token_iterator end;
        for (; iter != end; ++iter) {
            parts.push_back(convert(iter->str()));
        }
        return parts;
    };
    sort(data.begin(), data.end(), [&](string a, string b) -> bool {
        return alphanum_key(a) < alphanum_key(b);
    });
    return data;
}

int main() {
    string video;
    cout << "Video or image:" << endl;
    cin >> video;

    if (video.find(".png") != string::npos || video.find(".jpg") != string::npos) {
        Mat img = imread(video, IMREAD_GRAYSCALE);
        int width = img.cols;
        int height = img.rows;
        img /= 4;
        vector<vector<uchar>> img_list;
        for (int i = 0; i < height; ++i) {
            vector<uchar> row;
            for (int j = 0; j < width; ++j) {
                row.push_back(img.at<uchar>(i, j));
            }
            img_list.push_back(row);
        }
        string asciis = "$@B%8&WM#*oahkbdpqwmZO0QLCJUYXzcvunxrjft/|)1}]?-_+~>i!lI;:,\"^`'. ";
        string image = "";
        for (auto row : img_list) {
            for (auto item : row) {
                image += asciis[item];
            }
            image += "\n";
        }
        vector<string> image_vec;
        stringstream ss(image);
        string line;
        while (getline(ss, line, '\n')) {
            image_vec.push_back(line);
        }
        Mat img_out(height * 6, width * 6 + 4, CV_8UC3, Scalar(255, 255, 255));
        for (int i = 0; i < image_vec.size(); ++i) {
            putText(img_out, image_vec[i], Point(0, i * 6), FONT_HERSHEY_SIMPLEX, 0.2, Scalar(0, 0, 0), 1);
        }
        imwrite("ascii.jpg", img_out);
    } else {
        system("mkdir mcm_frames");
        system("mkdir heatsch");
        system("ffmpeg -i " + video + " mcm_frames/test-%03d.jpg");
        VideoCapture cap(video);
        int fps = cap.get(CAP_PROP_FPS);
        int height = cap.get(CAP_PROP_FRAME_HEIGHT);
        int width = cap.get(CAP_PROP_FRAME_WIDTH);
        vector<string> lst;
        for (const auto& entry : directory_iterator("mcm_frames")) {
