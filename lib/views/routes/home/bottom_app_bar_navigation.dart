// 🐦 Flutter imports:
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class FABBottomAppBarItem {
  FABBottomAppBarItem({required this.iconData, required this.text});
  IconData iconData;
  String text;
}

class FABBottomAppBar extends StatefulWidget {
  const FABBottomAppBar({
    Key? key,
    required this.items,
    this.centerItemText,
    this.height = 60,
    this.iconSize = 24.0,
    required this.backgroundColor,
    required this.defaultColor,
    required this.selectedBarColor,
    required this.selectedColor,
    this.notchedShape,
    required this.onTabSelected,
    required this.textStyle,
  })  : assert(items.length == 2 || items.length == 4),
        super(key: key);

  final List<FABBottomAppBarItem> items;
  final String? centerItemText;
  final NotchedShape? notchedShape;
  final double height;
  final double iconSize;
  final TextStyle textStyle;
  final Color backgroundColor;
  final Color defaultColor;
  final Color? selectedBarColor;
  final Color selectedColor;
  final ValueChanged<int> onTabSelected;

  @override
  State<StatefulWidget> createState() => FABBottomAppBarState();
}

class FABBottomAppBarState extends State<FABBottomAppBar> {
  int _selectedIndex = 0;

  void _updateIndex(int index) {
    widget.onTabSelected(index);
    setState(() {
      _selectedIndex = index;
    });
  }

  late BannerAd staticAd;
  bool staticAdsLoaded = false;
  late BannerAd inlineAd;
  bool inlineAdsLoaded = false;

  void loadStaticAd() {
    staticAd = BannerAd(
        size: AdSize.banner,
        adUnitId: "ca-app-pub-7302379484663726/8633275747",
        listener: BannerAdListener(onAdLoaded: (ad) {
          staticAdsLoaded = true;
          setState(() {});
        }, onAdFailedToLoad: (ad, error) {
          ad.dispose();
        }),
        request: request);

    staticAd.load();
  }

  void loadInlineAd() {
    inlineAd = BannerAd(
        size: AdSize.banner,
        adUnitId: "ca-app-pub-7302379484663726/8633275747",
        listener: BannerAdListener(onAdLoaded: (ad) {
          inlineAdsLoaded = true;
          setState(() {});
        }, onAdFailedToLoad: (ad, error) {
          ad.dispose();
        }),
        request: request);

    inlineAd.load();
  }

  InterstitialAd? interstitialAd;
  int interstitialAttempts = 0;
  int maxAttempts = 3;
  AdRequest request = AdRequest(
      // keywords: ['', ''],
      // contentUrl: '',
      // nonPersonalizedAds: false
      );

  void createInterstialAd() {
    InterstitialAd.load(
        adUnitId: "ca-app-pub-7302379484663726/4227304489",
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) {
          interstitialAd = ad;
          interstitialAttempts = 0;
        }, onAdFailedToLoad: (error) {
          interstitialAttempts++;
          interstitialAd = null;
          print('falied to load ${error.message}');

          if (interstitialAttempts <= maxAttempts) {
            createInterstialAd();
          }
        }));
  }

  void showInterstitialAd() {
    Random random = new Random();
    int randomNumber = random.nextInt(5);

    if (randomNumber != 0) return;

    log(randomNumber);

    if (interstitialAd == null) {
      print('trying to show before loading');
      return;
    }

    interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) => print('ad showed $ad'),
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          createInterstialAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          print('failed to show the ad $ad');

          createInterstialAd();
        });

    interstitialAd!.show();
    interstitialAd = null;
  }

  @override
  void initState() {
    loadStaticAd();
    loadInlineAd();
    createInterstialAd();
    // Future.delayed(Duration(milliseconds: 1), () => _updateIndex(1));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> items = List.generate(widget.items.length, (int index) {
      return _buildTabItem(
        item: widget.items[index],
        index: index,
        onPressed: _updateIndex,
      );
    });
    items.insert(items.length >> 1, _buildMiddleTabItem());

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        BottomAppBar(
          shape: widget.notchedShape,
          color: widget.backgroundColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items,
          ),
        ),
        if (staticAdsLoaded)
          Container(
            alignment: Alignment.center,
            child: AdWidget(ad: staticAd),
            width: staticAd.size.width.toDouble(),
            height: staticAd.size.height.toDouble(),
          ),
      ],
    );
  }

  Widget _buildMiddleTabItem() {
    return Expanded(
      child: SizedBox(
        height: widget.height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: widget.iconSize),
            Text(
              widget.centerItemText ?? '',
              style: widget.textStyle.copyWith(color: widget.selectedColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem({
    required FABBottomAppBarItem item,
    required int index,
    required ValueChanged<int> onPressed,
  }) {
    final Color color =
        _selectedIndex == index ? widget.selectedColor : widget.defaultColor;
    final Color? barColor =
        _selectedIndex == index ? widget.selectedBarColor : Colors.transparent;
    return Expanded(
      child: SizedBox(
        height: widget.height,
        child: InkWell(
          onTap: () {
            print("Hello World");
            showInterstitialAd();
            onPressed(index);
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                    color: barColor ?? Colors.transparent, width: 4.0),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(item.iconData, color: color, size: widget.iconSize),
                Text(
                  item.text,
                  style: widget.textStyle.copyWith(color: color),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
