// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';

// 🌎 Project imports:
import 'package:nid/logic/models/note.dart';
import 'package:nid/views/utils/extensions/view_extensions.dart';

class NoteItem extends StatelessWidget {
  const NoteItem({Key? key, required this.item}) : super(key: key);

  final Note item;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 121.w,
          height: 3.h,
          color: ExpandedColor.fromHex(item.hexColor),
        ),
        SizedBox(height: 13.h),
        Text(
          item.description,
          style: textTheme.subtitle1!.copyWith(fontSize: 16.sp, height: 2),
        ),
        SizedBox(height: 20.h)
      ],
    );
  }
}
