#include <iostream>
#include <conio.h>
#include <Windows.h>

using namespace std;

const int WIDTH = 40;
const int HEIGHT = 20;
const char PADDLE_CHAR = '=';
const char BALL_CHAR = '*';

int ballX, ballY;
int paddleX;
int directionX, directionY;
bool gameOver;

void Setup() {
    ballX = WIDTH / 2;
    ballY = HEIGHT / 2;
    paddleX = WIDTH / 2 - 2;
    directionX = 1;
    directionY = 1;
    gameOver = false;
}

void Draw() {
    system("cls");
    for (int i = 0; i < WIDTH + 2; i++)
        cout << "#";
    cout << endl;

    for (int i = 0; i < HEIGHT; i++) {
        for (int j = 0; j < WIDTH; j++) {
            if (j == 0)
                cout << "#";
            if (i == ballY && j == ballX)
                cout << BALL_CHAR;
            else if (i == HEIGHT - 1 && j >= paddleX && j < paddleX + 4)
                cout << PADDLE_CHAR;
            else
                cout << " ";
            if (j == WIDTH - 1)
                cout << "#";
        }
        cout << endl;
    }

    for (int i = 0; i < WIDTH + 2; i++)
        cout << "#";
    cout << endl;
}

void Input() {
    if (_kbhit()) {
        char key = _getch();
        if (key == 'a' || key == 'A')
            paddleX -= 2;
        if (key == 'd' || key == 'D')
            paddleX += 2;
        if (key == 'q' || key == 'Q')
            gameOver = true;
    }
}

void Logic() {
    if (ballX == 0 || ballX == WIDTH - 1)
        directionX = -directionX;
    if (ballY == 0)
        directionY = 1;
    if (ballY == HEIGHT - 1) {
        if (ballX >= paddleX && ballX < paddleX + 4)
            directionY = -directionY;
        else
            gameOver = true;
    }

    ballX += directionX;
    ballY += directionY;
}

int main() {
    Setup();

    while (!gameOver) {
        Draw();
        Input();
        Logic();
        Sleep(10); // Sleep for a short duration to control game speed
    }

    cout << "Game Over!" << endl;

    return 0;
}
