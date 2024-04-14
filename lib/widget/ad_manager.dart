import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-1234567890123456/1234567890'; // Ganti dengan ID iklan banner Android Anda
    } else if (Platform.isIOS) {
      return 'ca-app-pub-1234567890123456/1234567890'; // Ganti dengan ID iklan banner iOS Anda
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-1234567890123456/1234567890'; // Ganti dengan ID iklan interstitial Android Anda
    } else if (Platform.isIOS) {
      return 'ca-app-pub-1234567890123456/1234567890'; // Ganti dengan ID iklan interstitial iOS Anda
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-1234567890123456/1234567890'; // Ganti dengan ID iklan rewarded Android Anda
    } else if (Platform.isIOS) {
      return 'ca-app-pub-1234567890123456/1234567890'; // Ganti dengan ID iklan rewarded iOS Anda
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
