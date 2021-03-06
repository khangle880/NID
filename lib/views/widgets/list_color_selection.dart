// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';

// 🌎 Project imports:
import 'package:nid/global/constants/app_constants.dart';
import 'package:nid/views/utils/extensions/view_extensions.dart';

class ListColorSelection extends StatelessWidget {
  const ListColorSelection({
    Key? key,
    required this.onSelected,
    required this.colorSelected,
  }) : super(key: key);

  final Function(Color) onSelected;
  final Color colorSelected;

  @override
  Widget build(BuildContext context) {
    final listColor = ColorConstants.kListColorPickup;
    return SizedBox(
      height: 43.h,
      child: ListView.separated(
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(width: 8.w);
        },
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: listColor.length,
        itemBuilder: (BuildContext context, int index) {
          final itemColor = listColor[index];
          return Container(
            width: 43.w,
            decoration: BoxDecoration(
              color: itemColor,
              borderRadius: BorderRadius.circular(5.r),
            ),
            child: IconButton(
              icon: Icon(
                colorSelected == itemColor ? Icons.done : null,
                color: ExpandedColor.fromHex("#FFFFFF"),
              ),
              onPressed: () => onSelected(itemColor),
            ),
          );
        },
      ),
    );
  }
}
