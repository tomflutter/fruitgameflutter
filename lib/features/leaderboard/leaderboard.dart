class Leaderboard {
  // Implementasi papan peringkat
  // Contoh: Menyimpan skor tertinggi dan menampilkan papan peringkat
  List<int> highScores = [];

  void updateHighScore(int score) {
    highScores.add(score);
    highScores.sort((a, b) => b.compareTo(a));
  }

  void displayLeaderboard() {
    print('Leaderboard:');
    for (int i = 0; i < highScores.length; i++) {
      print('${i + 1}. ${highScores[i]}');
    }
  }
}
