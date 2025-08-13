class PowerUps {
  // Metode untuk menghapus semua buah-buahan pada baris tertentu
  void clearRow(List<List<String>> grid, int row) {
    for (int j = 0; j < grid[row].length; j++) {
      grid[row][j] = '';
    }
  }
}
