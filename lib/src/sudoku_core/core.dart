import 'generator.dart' as generator;
import 'tools.dart';

List<List<int>> _defaultGrid = List.generate(
  9,
  (row) => List.generate(9, (col) => 0),
);

class Sudoku {
  late List<List<int>> _grid, puzzle, solution;
  late int _time;
  late generator.Level level;
  late int completionTime;

  List<List<int>> get grid => _grid;
  int get time => _time;

  Sudoku() {
    _grid = copyGrid(_defaultGrid);
    solution = copyGrid(_defaultGrid);
    _time = 0;
  }

  static List<List<int>> copyGrid(List<List<int>> grid) {
    return List.generate(9, (i) => List<int>.from(grid[i]));
  }

  Sudoku copyWith({
    List<List<int>>? grid,
    List<List<int>>? solution,
    List<List<int>>? puzzle,
    int? time,
    generator.Level? level,
    int? completionTime,
  }) {
    final copy = Sudoku();
    copy._grid = grid ?? copyGrid(_grid);
    copy._time = time ?? _time;
    copy.level = level ?? this.level;
    copy.solution = solution != null
        ? copyGrid(solution)
        : copyGrid(this.solution);
    copy.puzzle = puzzle != null ? copyGrid(puzzle) : copyGrid(this.puzzle);
    copy.completionTime = completionTime ?? this.completionTime;
    return copy;
  }

  Sudoku.fromGrid(List<List<int>> grid) {
    if (grid.length != 9 || grid.first.length != 9) {
      throw Exception('Invalid grid');
    }
    for (var row = 0; row < 9; row++) {
      if (grid[row].length != 9) {
        throw Exception('Invalid grid');
      }

      for (var col = 0; col < 9; col++) {
        if (grid[row][col] < 0 || grid[row][col] > 9) {
          throw Exception('Invalid grid');
        }
      }
    }
    _grid = copyGrid(grid);
    solution = copyGrid(grid);
    _time = 0;
  }

  void debug() {
    print('------- DEBUG -------');
    print('Grid: $_grid');
    print('Solution: $solution');
    print('Time: $_time');
    print('---------------------');
  }

  factory Sudoku.generate(generator.Level level) {
    return generator.generateGrid(level: level);
  }

  @override
  String toString() {
    return 'grid: $_grid,\n solution: $solution,\n time: $_time,\n level: $level';
  }
}
