// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';

// 🌎 Project imports:
import 'package:nid/views/utils/extensions/view_extensions.dart';
import 'reset_password_form.dart';

class ResetPasswordBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const description = '''
Reset code was sent to your phone. Please
enter the code and create new password''';

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        'Reset Password',
        style: Theme.of(context).textTheme.headline4,
      ),
      SizedBox(height: 10.h),
      Text(description,
          style: Theme.of(context)
              .textTheme
              .bodyText2!
              .copyWith(color: ExpandedColor.fromHex("#9B9B9B")),
          textAlign: TextAlign.left),
      SizedBox(height: 40.h),
      ResetPasswordForm(),
    ]);
  }
}
