import 'dart:async';
import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'features/level/level.dart';
import 'features/animation/animation.dart';
import 'features/sound/sound.dart';
import 'features/settings/settings.dart';

void main() {
  runApp(MaterialApp(home: FruitCrushGame()));
}

class FruitCrushGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Fruit Crush', home: FruitCrushHomePage());
  }
}

class FruitCrushHomePage extends StatefulWidget {
  @override
  _FruitCrushHomePageState createState() => _FruitCrushHomePageState();
}

class _FruitCrushHomePageState extends State<FruitCrushHomePage> {
  final int rows = 8;
  final int columns = 8;
  final List<String> fruits = ['🍎', '🍊', '🍇', '🍌', '🍉', '🍓'];
  late List<List<String>> grid;
  Random random = Random();
  int score = 0;
  late Timer timer;
  bool isGameOver = false;
  Level currentLevel = Level(1, 1000);
  late FruitAnimation animation;
  late Sound sound;
  late Settings settings;

  int currentLevelIndex = 0;
  List<Level> levels = [Level(1, 1000), Level(2, 2000)];

  int timeLeft = 60;
  final int timePerMove = 10;

  @override
  void initState() {
    super.initState();
    initializeGrid();
    startTimer();
    animation = FruitAnimation();
    sound = Sound();
    settings = Settings();
  }

  void initializeGrid() {
    grid = List.generate(rows, (_) => List.filled(columns, ''));
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < columns; j++) {
        grid[i][j] = fruits[random.nextInt(fruits.length)];
      }
    }
  }

  void gameOver() {
    setState(() {
      isGameOver = true;
    });
    timer.cancel();
    showGameOverDialog(context);
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!isGameOver) {
        setState(() {
          timeLeft--;
          if (timeLeft <= 0) {
            gameOver();
          }
        });
      }
    });
  }

  List<int> selectedCells = [];

  void onTapCell(int row, int column) {
    if (!isGameOver) {
      setState(() {
        String selectedFruit = grid[row][column];
        if (selectedFruit != '') {
          timeLeft -= timePerMove;

          if (selectedCells.contains(row * columns + column)) {
            // Deselect the cell
            selectedCells.remove(row * columns + column);
          } else {
            selectedCells.add(row * columns + column);
          }

          if (selectedCells.length >= 3) {
            bool isValidSelection = true;
            for (int i = 1; i < selectedCells.length; i++) {
              int prevRow = selectedCells[i - 1] ~/ columns;
              int prevColumn = selectedCells[i - 1] % columns;
              int currentRow = selectedCells[i] ~/ columns;
              int currentColumn = selectedCells[i] % columns;
              if (!((prevRow == currentRow &&
                          (prevColumn - currentColumn).abs() == 1) ||
                      (prevColumn == currentColumn &&
                          (prevRow - currentRow).abs() == 1)) ||
                  grid[prevRow][prevColumn] !=
                      grid[currentRow][currentColumn]) {
                isValidSelection = false;
                break;
              }
            }

            if (isValidSelection) {
              for (int cellIndex in selectedCells) {
                int r = cellIndex ~/ columns;
                int c = cellIndex % columns;
                grid[r][c] = '';
              }
              animation.playFruitExplosionAnimation();
              // Update score
              score += selectedCells.length * 10;
              selectedCells.clear();
              if (settings.soundEnabled) {
                sound.playFruitExplosionSound();
              }
              if (!checkPossibleMoves()) {
                checkLevelCompletion();
              }
            } else {
              selectedCells.clear();
            }
          }
        }
      });
    }
  }

  void showGameOverDialog(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.topSlide,
      title: 'Game Over',
      desc: 'score kamu: $score',
      btnOkOnPress: () {
        restartGame();
      },
      dismissOnTouchOutside: false,
    ).show();
  }

  void checkLevelCompletion() {
    if (score >= currentLevel.targetScore) {
      if (currentLevelIndex < levels.length - 1) {
        currentLevelIndex++;
        currentLevel = levels[currentLevelIndex];
        startTimer();
      } else {
        gameOver();
      }
    }
  }

  void swapFruits(int row, int column) {}

  void checkAndRemoveMatches() {}

  bool checkPossibleMoves() {
    return false;
  }

  void restartGame() {
    setState(() {
      isGameOver = false;
      score = 0;
      timeLeft = 60;
      initializeGrid();
      startTimer();
    });
  }

  void showAlertDialog(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.scale,
      title: 'IDR Information',
      desc: 'saldo anda belum mencukupi',
      btnOkOnPress: () {},
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fruit Crush'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                showAlertDialog(context);
              },
              child: Row(
                children: [
                  Icon(Icons.account_balance_wallet),
                  SizedBox(width: 4),
                  Text('IDR $score', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
              ),
              itemCount: rows * columns,
              itemBuilder: (BuildContext context, int index) {
                int row = index ~/ columns;
                int column = index % columns;
                return GestureDetector(
                  onTap: () => onTapCell(row, column),
                  child: Container(
                    decoration: BoxDecoration(border: Border.all()),
                    child: Center(
                      child: Text(
                        grid[row][column],
                        style: TextStyle(fontSize: 24.0),
                      ),
                    ),
                    width: 100.0,
                    height: 100.0,
                  ),
                );
              },
            ),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
