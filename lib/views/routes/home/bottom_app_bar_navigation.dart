// 🐦 Flutter imports:
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

  static const AdRequest request = AdRequest();

  void loadStaticAd() {
    staticAd = BannerAd(
        size: AdSize.banner,
        adUnitId: BannerAd.testAdUnitId,
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
        adUnitId: BannerAd.testAdUnitId,
        listener: BannerAdListener(onAdLoaded: (ad) {
          inlineAdsLoaded = true;
          setState(() {});
        }, onAdFailedToLoad: (ad, error) {
          ad.dispose();
        }),
        request: request);

    inlineAd.load();
  }

  @override
  void initState() {
    loadStaticAd();
    loadInlineAd();
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
          onTap: () => onPressed(index),
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
