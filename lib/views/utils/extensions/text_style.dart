// 🐦 Flutter imports:
import 'package:flutter/widgets.dart';

// 🌎 Project imports:
import 'package:nid/views/utils/extensions/view_extensions.dart';

extension ExpandedTextStyle on TextStyle {
  TextStyle toBlurColor() {
    return copyWith(color: ExpandedColor.fromHex("#9E9E9E"));
  }

  Size textSize(String text) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: this),
        maxLines: 1,
        textDirection: TextDirection.ltr)
      ..layout();
    return textPainter.size;
  }
}
