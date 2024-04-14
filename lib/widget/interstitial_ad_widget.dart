import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class interstitialAd extends StatelessWidget {
  final VoidCallback onAdClosed; // Tambahkan parameter onAdClosed

  interstitialAd({required this.onAdClosed}); // Tambahkan konstruktor

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Ads Admob Interstitial Unit'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  loadInterstitialAd(context, "FirstInterstitial",
                      onAdClosed); // Tambahkan onAdClosed ke dalam pemanggilan fungsi
                },
                child: Text('Show First Interstitial Ad'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  loadInterstitialAd(context, "SecondInterstitial",
                      onAdClosed); // Tambahkan onAdClosed ke dalam pemanggilan fungsi
                },
                child: Text('Show Second Interstitial Ad'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void loadInterstitialAd(
      BuildContext context, String adName, VoidCallback onAdClosed) {
    InterstitialAd.load(
      adUnitId: "ca-app-pub-7298155068094134/1855319133",
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (InterstitialAd ad) {
              onAdClosed(); // Panggil callback onAdClosed saat iklan ditutup
            },
          );
          ad.show();
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd $adName failed to load: $error');
        },
      ),
    );
  }
}
