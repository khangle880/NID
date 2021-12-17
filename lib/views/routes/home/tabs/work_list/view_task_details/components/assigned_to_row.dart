// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// 🌎 Project imports:
import 'package:nid/logic/blocs/firestore/firestore_bloc.dart';
import 'package:nid/logic/models/public_user_info.dart';
import 'package:nid/logic/utils/extensions/logic_extensions.dart';
import 'package:nid/views/utils/extensions/view_extensions.dart';
import 'package:nid/views/widgets/network_avatar.dart';

class AssignedToRow extends StatelessWidget {
  const AssignedToRow({
    Key? key,
    required this.assignedToId,
  }) : super(key: key);
  final String assignedToId;

  @override
  Widget build(BuildContext context) {
    final assignedInfo = context
            .read<FirestoreBloc<PublicUserInfo>>()
            .allDoc
            .findById(assignedToId) ??
        PublicUserInfo(
          id: "",
          email: "Not Found",
          name: "Not Found",
          avatarLink: "",
          status: false,
          description: "Not Found",
        );
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: <Widget>[
        NetworkAvatar(
          link: assignedInfo.avatarLink,
          width: 44.h,
          height: 44.h,
        ),
        SizedBox(width: 10.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Assigned to",
              overflow: TextOverflow.ellipsis,
              style: textTheme.button!.toBlurColor(),
            ),
            SizedBox(height: 2.h),
            Text(
              assignedInfo.name,
              overflow: TextOverflow.ellipsis,
              style: textTheme.subtitle1!.copyWith(fontSize: 16.sp),
            ),
          ],
        ),
      ],
    );
  }
}
