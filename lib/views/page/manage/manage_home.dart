import 'dart:ui';

import 'package:detect_license_plate_app/config/constants/app_colors.dart';
import 'package:detect_license_plate_app/config/constants/app_constants.dart';
import 'package:detect_license_plate_app/views/common/common_button.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../ab_mob_help.dart';
import 'my_paint.dart';
import 'manage_model.dart';
import 'manage_page.dart';

class ManageHome extends StatefulWidget {
  const ManageHome({super.key});

  @override
  State<ManageHome> createState() => _ManageHomeState();
}

class _ManageHomeState extends State<ManageHome> {
  BannerAd? _bannerAd;

  // COMPLETE: Add _interstitialAd
  InterstitialAd? _interstitialAd;

  // COMPLETE: Add _rewardedAd
  RewardedAd? _rewardedAd;

  @override
  void initState() {
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          debugPrint('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();

    _loadInterstitialAd();
    super.initState();
  }

  void _moveToHome() {}

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          print('Load Success');
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              _moveToHome();
            },
          );

          setState(() {
            _interstitialAd = ad;
          });
        },
        onAdFailedToLoad: (err) {
          print('Load Failed to load an interstitial ad: ${err.message}');
        },
      ),
    );
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppColors.blueMain,
          automaticallyImplyLeading: false,
          title: const Text(
            'Manage Page',
            style: TextStyle(
                color: AppColors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              AppConstants.kSpacingItem16,
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.blueMain,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.white,
                    size: 20,
                  ),
                  title: const Text(
                    'Manage Sample',
                    style: TextStyle(
                        color: AppColors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ManagePage(),
                      ),
                    );
                  },
                ),
              ),
              AppConstants.kSpacingItem16,
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.yellow1,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.white,
                    size: 20,
                  ),
                  title: const Text(
                    'Manage Model',
                    style: TextStyle(
                        color: AppColors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ManageModelPage(),
                      ),
                    );
                  },
                ),
              ),
              AppConstants.kSpacingItem32,
              InkWell(
                  onTap: () {
                    if (_interstitialAd != null) {
                      _interstitialAd?.show();
                    } else {
                      _moveToHome();
                    }
                  },
                  child: Text('Show Interstitial Ad')),

              /// TODO show Admob with banner
              if (_bannerAd != null)
                Center(
                  child: SizedBox(
                    width: _bannerAd!.size.width.toDouble(),
                    height: _bannerAd!.size.height.toDouble(),
                    child: AdWidget(ad: _bannerAd!),
                  ),
                ),
            ],
          ),
        ));
  }
}
