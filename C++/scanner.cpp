#include <iostream>
#include <string>

using namespace std;

enum TokenType {
    NUMBER,
    PLUS,
    MINUS,
    MULTIPLY,
    DIVIDE,
    END_OF_FILE
};

class Token {
public:
    TokenType type;
    double value;
};

class Scanner {
public:
    Scanner(string input) {
        this->input = input;
        this->currentPosition = 0;
    }

    Token getNextToken() {
        Token token;
        token.value = 0;

        // Skip whitespace
        while (currentPosition < input.length() && isspace(input[currentPosition]))
            currentPosition++;

        // Check for end of file
        if (currentPosition >= input.length()) {
            token.type = END_OF_FILE;
            return token;
        }

        // Check for number
        if (isdigit(input[currentPosition])) {
            double value = 0;
            while (currentPosition < input.length() && isdigit(input[currentPosition])) {
                value = value * 10 + (input[currentPosition] - '0');
                currentPosition++;
            }
            token.type = NUMBER;
            token.value = value;
            return token;
        }

        // Check for operators
        switch (input[currentPosition]) {
            case '+':
                token.type = PLUS;
                currentPosition++;
                break;
            case '-':
                token.type = MINUS;
                currentPosition++;
                break;
            case '*':
                token.type = MULTIPLY;
                currentPosition++;
                break;
            case '/':
                token.type = DIVIDE;
                currentPosition++;
                break;
            default:
                cerr << "Invalid character: " << input[currentPosition] << endl;
                currentPosition++;
                break;
        }

        return token;
    }

private:
    string input;
    int currentPosition;
};

int main() {
    Scanner scanner("1 + 2 * 3 - 4 / 2");

    Token token;
    do {
        token = scanner.getNextToken();

        switch (token.type) {
            case NUMBER:
                cout << "Number: " << token.value << endl;
                break;
            case PLUS:
                cout << "Plus" << endl;
                break;
            case MINUS:
                cout << "Minus" << endl;
                break;
            case MULTIPLY:
                cout << "Multiply" << endl;
                break;
            case DIVIDE:
                cout << "Divide" << endl;
                break;
            case END_OF_FILE:
                cout << "End of file" << endl;
                break;
            default:
                break;
        }
    } while (token.type != END_OF_FILE);

    return 0;
}
