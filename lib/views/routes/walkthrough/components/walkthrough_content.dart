// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

// 🌎 Project imports:
import 'package:nid/views/utils/extensions/view_extensions.dart';

class WalkthroughContent extends StatelessWidget {
  const WalkthroughContent({
    Key? key,
    required this.image,
    required this.title,
    required this.description,
  }) : super(key: key);
  final String title, description, image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 392.h,
          child: SvgPicture.asset(
            image,
            width: 300.w,
          ),
        ),
        Text(
          title,
          style: Theme.of(context).textTheme.headline5,
        ),
        SizedBox(height: 9.h),
        Text(
          description,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                color: ExpandedColor.fromHex("#313131").withOpacity(0.8),
              ),
        ),
      ],
    );
  }
}
