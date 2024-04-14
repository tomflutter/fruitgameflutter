class Currency {
  // Implementasi mata uang dalam game
  int coins = 0;

  void addCoins(int amount) {
    coins += amount;
  }

  void spendCoins(int amount) {
    if (coins >= amount) {
      coins -= amount;
    } else {
      print('Koin tidak cukup!');
    }
  }
}
