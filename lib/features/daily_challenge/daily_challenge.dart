class DailyChallenge {
  // Implementasi tantangan harian
  // Contoh: Menampilkan tantangan harian dan memberikan imbalan kepada pemain
  String challengeDescription = 'Tantangan: Cetak skor 1000 poin atau lebih';

  bool isChallengeCompleted(int score) {
    return score >= 1000;
  }

  int getReward() {
    return 50; // Contoh: Memberikan 50 koin sebagai imbalan
  }
}
