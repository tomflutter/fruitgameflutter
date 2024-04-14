import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class GameOverDialog {
  void show(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.topSlide,
      title: 'Game Over',
      desc: 'Waktu habis!',
      btnOkText: 'OK',
      btnOkOnPress: () {
        // Action setelah tombol OK ditekan, misalnya memulai permainan lagi
      },
    ).show();
  }
}
