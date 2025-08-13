import 'dart:async';

class GameLogic {
  late Timer timer;
  late bool isGameOver;

  void startGame() {
    // Atur timer dan logika permainan di sini
    // Contoh: mulai timer, atur logika permainan, dll.
  }

  void gameOver() {
    isGameOver = true;
    timer.cancel();
    // Panggil fungsi untuk menampilkan dialog "Game Over"
    // gameOverDialog(context);
  }

  // Tambahkan logika permainan lainnya di sini
}
