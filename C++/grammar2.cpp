#include <iostream>
#include <string>
#include <regex>

int main() {
    std::string input;
    std::cout << "Enter text: ";
    std::getline(std::cin, input);

    // Correct capitalization of first letter
    if (input.length() > 0) {
        input[0] = toupper(input[0]);
    }

    // Correct capitalization of sentences
    for (int i = 1; i < input.length(); i++) {
        if (input[i] == '.' && input[i+1] != ' ' && i+1 < input.length()) {
            input[i+1] = toupper(input[i+1]);
        }
    }
    // Check for double spaces
    std::regex double_space("  ");
    input = std::regex_replace(input, double_space, " ");
    // Check for common punctuation errors
    std::regex punctuation("([a-zA-Z])[,;:]([a-zA-Z])");
    input = std::regex_replace(input, punctuation, "$1 $2");
    std::cout << "Corrected text: " << input << std::endl;
    return 0;
}
