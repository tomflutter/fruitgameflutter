class Settings {
  // Implementasi pengaturan
  bool soundEnabled = true;
  bool musicEnabled = true;

  void toggleSound() {
    soundEnabled = !soundEnabled;
  }

  void toggleMusic() {
    musicEnabled = !musicEnabled;
  }
}
