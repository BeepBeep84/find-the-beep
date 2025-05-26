import random

def get_previous_letters(grid, i, j, dx, dy):
    seq = ''
    for k in range(1, 4):
        x = i - k * dx
        y = j - k * dy
        if 0 <= x < len(grid) and 0 <= y < len(grid[0]):
            seq = grid[x][y] + seq  # Build the sequence from oldest to newest
        else:
            break
    return seq

def generate_grid(rows, cols):
    directions = [(-1, 0),  # up
                  (-1, 1),  # up-right
                  (0, 1),   # right
                  (1, 1),   # down-right
                  (1, 0),   # down
                  (1, -1),  # down-left
                  (0, -1),  # left
                  (-1, -1)] # up-left

    letters = ['B', 'E', 'P']

    while True:
        grid = [['' for _ in range(cols)] for _ in range(rows)]
        conflict = False

        for i in range(rows):
            for j in range(cols):
                possible_letters = set(letters)

                for dx, dy in directions:
                    seq = get_previous_letters(grid, i, j, dx, dy)
                    if len(seq) >= 3:
                        if seq[-3:] == 'BEE':
                            possible_letters.discard('P')
                        if seq[-3:] == 'PEE':
                            possible_letters.discard('B')

                if not possible_letters:
                    conflict = True
                    break  # Conflict found, need to restart
                grid[i][j] = random.choice(list(possible_letters))
            if conflict:
                break

        if not conflict:
            return grid  # Successfully generated grid without conflicts

def print_grid(grid):
    for row in grid:
        print(' '.join(row))

def main():
    try:
        rows = int(input("Enter number of rows: "))
        cols = int(input("Enter number of columns: "))
    except ValueError:
        print("Please enter valid integers for rows and columns.")
        return

    if rows < 4 and cols < 4:
        print("Grid size should be at least 4x4 to avoid trivial cases.")
        return

    grid = generate_grid(rows, cols)
    print("\nGenerated Grid:")
    print_grid(grid)

if __name__ == "__main__":
    main()
