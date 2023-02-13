#include <iostream>
#include <fstream>
#include <algorithm>
#include <regex>
#include <vector>
#include <string>
#include <opencv2/opencv.hpp>

std::vector<std::string> split(const std::string &s, char delim) {
    std::vector<std::string> elems;
    std::stringstream ss(s);
    std::string item;
    while (std::getline(ss, item, delim)) {
        elems.push_back(item);
    }
    return elems;
}

std::vector<std::string> split(const std::string &s, const std::string &delim) {
    std::vector<std::string> elems;
    size_t pos = 0;
    size_t len = delim.length();
    size_t found;
    while ((found = s.find(delim, pos)) != std::string::npos) {
        elems.push_back(s.substr(pos, found - pos));
        pos = found + len;
    }
    elems.push_back(s.substr(pos));
    return elems;
}

bool alphanumeric_compare(const std::string &a, const std::string &b) {
    std::vector<std::string> a_elems = split(a, "0123456789");
    std::vector<std::string> b_elems = split(b, "0123456789");
    int i = 0;
    int j = 0;
    while (i < a_elems.size() && j < b_elems.size()) {
        std::string a_num_str;
        std::string b_num_str;
        std::regex pattern("\\d+");
        std::smatch match;
        if (std::regex_search(a_elems[i], match, pattern)) {
            a_num_str = match.str();
        }
        if (std::regex_search(b_elems[j], match, pattern)) {
            b_num_str = match.str();
        }
        int a_num = 0;
        int b_num = 0;
        if (!a_num_str.empty() && !b_num_str.empty()) {
            a_num = std::stoi(a_num_str);
            b_num = std::stoi(b_num_str);
            if (a_num != b_num) {
                return a_num < b_num;
            }
        } else {
            int comp = a_elems[i].compare(b_elems[j]);
            if (comp != 0) {
                return comp < 0;
            }
        }
        i++;
        j++;
    }
    return i == a_elems.size() && j < b_elems.size();
}

std::vector<std::string> sorted_alphanumeric(const std::vector<std::string> &data) {
    std::vector<std::string> sorted
