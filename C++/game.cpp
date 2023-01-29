#include <iostream>
#include <vector>
#include <ctime>


using namespace std;

const int ROWS = 30;
const int COLS = 30;

vector<vector<int>> grid(ROWS, vector<int>(COLS));
vector<vector<int>> newGrid(ROWS, vector<int>(COLS));

void initializeGrid() {
    // Initialize the grid with random values
    for (int row = 0; row < ROWS; row++) {
        for (int col = 0; col < COLS; col++) {
            grid[row][col] = rand() % 2;
        }
    }
}

void displayGrid() {
    // Display the grid
    for (int row = 0; row < ROWS; row++) {
        for (int col = 0; col < COLS; col++) {
            cout << grid[row][col] << " ";
        }
        cout << endl;
    }
}

int countNeighbors(int row, int col) {
    int count = 0;
    for (int i = row - 1; i <= row + 1; i++) {
        for (int j = col - 1; j <= col + 1; j++) {
            if (i >= 0 && i < ROWS && j >= 0 && j < COLS) {
                if (grid[i][j] == 1 && !(i == row && j == col)) {
                    count++;
                }
            }
        }
    }
    return count;
}

void updateGrid() {
    // Update the grid for the next generation
    for (int row = 0; row < ROWS; row++) {
        for (int col = 0; col < COLS; col++) {
            int neighbors = countNeighbors(row, col);
            if (grid[row][col] == 1) {
                if (neighbors < 2 || neighbors > 3) {
                    newGrid[row][col] = 0;
                }
                else {
                    newGrid[row][col] = 1;
                }
            }
            else {
                if (neighbors == 3) {
                    newGrid[row][col] = 1;
                }
                else {
                    newGrid[row][col] = 0;
                }
            }
        }
    }
    grid = newGrid;
}

int main() {
    srand(time(0));
    initializeGrid();
    while (true) {
        system("cls");
        displayGrid();
        updateGrid();
        _sleep(500);
    }
    return 0;
}
