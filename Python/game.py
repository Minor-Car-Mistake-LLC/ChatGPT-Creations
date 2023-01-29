import random

def create_grid(rows, cols):
    return [[random.randint(0,1) for _ in range(cols)] for _ in range(rows)]

def count_alive_neighbors(grid, row, col):
    count = 0
    for i in range(-1, 2):
        for j in range(-1, 2):
            if i == 0 and j == 0:
                continue
            r, c = row + i, col + j
            if (0 <= r < len(grid)) and (0 <= c < len(grid[0])):
                count += grid[r][c]
    return count

def step(grid):
    new_grid = [[0 for _ in range(len(grid[0]))] for _ in range(len(grid))]
    for row in range(len(grid)):
        for col in range(len(grid[0])):
            alive_neighbors = count_alive_neighbors(grid, row, col)
            if grid[row][col] == 1:
                if alive_neighbors < 2 or alive_neighbors > 3:
                    new_grid[row][col] = 0
                else:
                    new_grid[row][col] = 1
            else:
                if alive_neighbors == 3:
                    new_grid[row][col] = 1
    return new_grid

grid = create_grid(10, 10)
for _ in range(10):
    grid = step(grid)
    for row in grid:
        print(row)
    print()