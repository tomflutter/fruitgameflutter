import 'dart:async';
import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'features/level/level.dart';
import 'features/animation/animation.dart'; // Mengimpor file animasi
import 'features/sound/sound.dart'; // Mengimpor file suara
import 'features/settings/settings.dart';

void main() {
  runApp(MaterialApp(
    home: FruitCrushGame(),
  ));
}

class FruitCrushGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fruit Crush',
      home: FruitCrushHomePage(),
    );
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
  List<Level> levels = [
    Level(1, 1000),
    Level(2, 2000),
    // Tambahkan level lainnya di sini sesuai kebutuhan
  ];

  int timeLeft = 60; // Waktu dalam detik
  final int timePerMove = 10; // Waktu yang diberikan untuk setiap langkah

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
    showGameOverDialog(context); // Tampilkan dialog game over
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!isGameOver) {
        setState(() {
          // Kurangi waktu tersisa
          timeLeft--;

          // Periksa jika waktu habis
          if (timeLeft <= 0) {
            gameOver(); // Panggil gameOver jika waktu habis
          }
        });
      }
    });
  }

  List<int> selectedCells = []; // Menyimpan indeks sel yang dipilih

  void onTapCell(int row, int column) {
    if (!isGameOver) {
      setState(() {
        // Get fruit at tapped cell
        String selectedFruit = grid[row][column];

        // Check if the selected fruit is not empty
        if (selectedFruit != '') {
          // Kurangi waktu yang tersisa setiap kali pengguna melakukan langkah
          timeLeft -= timePerMove;

          // Check if the selected cell is already selected
          if (selectedCells.contains(row * columns + column)) {
            // Deselect the cell
            selectedCells.remove(row * columns + column);
          } else {
            // Add the cell to the selected list
            selectedCells.add(row * columns + column);
          }

          // Check if there are enough selected cells to explode
          if (selectedCells.length >= 3) {
            // Check if the selected cells are adjacent and have the same fruit
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

            // If selection is valid, explode the fruits
            if (isValidSelection) {
              for (int cellIndex in selectedCells) {
                int r = cellIndex ~/ columns;
                int c = cellIndex % columns;
                grid[r][c] = '';
              }
              // Play explode animation
              animation.playFruitExplosionAnimation();
              // Update score
              score += selectedCells.length *
                  10; // Example: Increment score by 10 for each matched fruit
              // Clear selected cells
              selectedCells.clear();
              // Add sound effect
              if (settings.soundEnabled) {
                sound.playFruitExplosionSound();
              }
              // Check for possible moves and game over condition
              if (!checkPossibleMoves()) {
                checkLevelCompletion(); // Moved here to check after updating the score
              }
            } else {
              // Deselect all cells
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
        // Restart the game
        restartGame();
      },
      dismissOnTouchOutside: false,
    ).show();
  }

  void checkLevelCompletion() {
    if (score >= currentLevel.targetScore) {
      // Cek apakah masih ada level berikutnya
      if (currentLevelIndex < levels.length - 1) {
        // Jika ada, pindah ke level berikutnya
        currentLevelIndex++;
        currentLevel = levels[currentLevelIndex];
        initializeGrid(); // Atur ulang grid untuk level baru
        startTimer(); // Mulai timer untuk level baru
      } else {
        // Jika tidak ada, tandai permainan sebagai selesai
        gameOver();
      }
    }
  }

  void swapFruits(int row, int column) {
    // Implement logic to swap fruits with adjacent cells
    // For example:
    // String temp = grid[row][column];
    // grid[row][column] = grid[row + 1][column];
    // grid[row + 1][column] = temp;
  }

  void checkAndRemoveMatches() {
    // Implement logic to check and remove matching fruits
    // For example:
    // for (int i = 0; i < rows; i++) {
    //   for (int j = 0; j < columns; j++) {
    //     // Check horizontally
    //     // Check vertically
    //     // Remove matching fruits and update score
    //   }
    // }
  }

  bool checkPossibleMoves() {
    // Implement logic to check if there are possible moves left
    // For example:
    // for (int i = 0; i < rows; i++) {
    //   for (int j = 0; j < columns; j++) {
    //     // Check adjacent cells
    //     // If there is any possible move return true
    //   }
    // }
    // Return false if no possible moves left
    return false;
  }

  void restartGame() {
    setState(() {
      isGameOver = false;
      score = 0;
      timeLeft = 60; // Atur ulang waktu
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
      desc: 'saldo anda belum mencukupi', // Deskripsi informasi IDR
      btnOkOnPress: () {}, // Fungsi kosong untuk tombol OK
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
                // Panggil fungsi showAlertDialog saat teks 'IDR' di tap
                showAlertDialog(
                  context,
                  //panggil show
                );
              },
              child: Row(
                children: [
                  Icon(Icons.account_balance_wallet), // Icon mata uang
                  SizedBox(width: 4), // Spasi kecil
                  Text(
                    'IDR $score', // Teks dengan jumlah mata uang IDR
                    style: TextStyle(fontSize: 16),
                    //Tampilkan showAlertDialog
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        // Tambahkan widget SingleChildScrollView di sini
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
                    decoration: BoxDecoration(
                      border: Border.all(),
                    ),
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
