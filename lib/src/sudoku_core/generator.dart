import 'dart:math';

import 'core.dart';

enum Level { easy, medium, hard, extreme, master }

bool unUsedInBox(Sudoku sudoku, int row, int col, int num) {
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      if (sudoku.grid[row + i][col + j] == num) {
        return false;
      }
    }
  }
  return true;
}

bool unUsedInCol(Sudoku sudoku, int col, int num) {
  for (int i = 0; i < 9; i++) {
    if (sudoku.grid[i][col] == num) {
      return false;
    }
  }
  return true;
}

bool unUsedInRow(Sudoku sudoku, int row, int num) {
  for (int i = 0; i < 9; i++) {
    if (sudoku.grid[row][i] == num) {
      return false;
    }
  }
  return true;
}

void fillBox(Sudoku sudoku, int row, int col) {
  List<int> numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      int randomIndex = Random().nextInt(numbers.length);
      int num = numbers[randomIndex];
      numbers.removeAt(randomIndex);
      sudoku.grid[row + i][col + j] = num;
    }
  }
}

void fillDiagonal(Sudoku sudoku) {
  for (int i = 0; i < 9; i += 3) {
    fillBox(sudoku, i, i);
  }
}

bool checkIfSafe(Sudoku sudoku, int row, int col, int num) {
  return (unUsedInRow(sudoku, row, num) &&
      unUsedInCol(sudoku, col, num) &&
      unUsedInBox(sudoku, row - row % 3, col - col % 3, num));
}

bool fillRemaining(Sudoku sudoku, int row, int col) {
  // check if reached end of grid

  if (row == 9) {
    return true;
  }

  // move to next row if current row is finised

  if (col == 9) {
    return fillRemaining(sudoku, row + 1, 0);
  }

  // Skip if cell is already filled
  if (sudoku.grid[row][col] != 0) {
    return fillRemaining(sudoku, row, col + 1);
  }

  // try filling current cell
  for (int number = 1; number <= 9; number++) {
    if (checkIfSafe(sudoku, row, col, number)) {
      sudoku.grid[row][col] = number;
      if (fillRemaining(sudoku, row, col + 1)) {
        return true;
      }
      sudoku.grid[row][col] = 0;
    }
  }

  return false;
}

void removeNumbers(Sudoku sudoku, int fill) {
  int k = 81 - fill;
  while (k > 0) {
    int row = Random().nextInt(9);
    int col = Random().nextInt(9);
    if (sudoku.grid[row][col] != 0) {
      sudoku.grid[row][col] = 0;
      k--;
    }
  }
}

Sudoku generateGrid({Level? level}) {
  late int fill;
  level ??= Level.medium;

  switch (level) {
    case Level.easy:
      fill = 60;
      break;
    case Level.medium:
      fill = 50;
      break;
    case Level.hard:
      fill = 40;
      break;
    case Level.extreme:
      fill = 30;
      break;
    case Level.master:
      fill = 20;
      break;
  }
  final sudoku = Sudoku();
  sudoku.level = level;

  fillDiagonal(sudoku);

  fillRemaining(sudoku, 0, 0);

  sudoku.solution = Sudoku.copyGrid(sudoku.grid);

  removeNumbers(sudoku, fill);
  sudoku.puzzle = Sudoku.copyGrid(sudoku.grid);

  return sudoku;
}
