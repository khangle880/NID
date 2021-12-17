// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// 🌎 Project imports:
import 'package:nid/logic/blocs/profile/profile_bloc.dart';
import 'package:nid/views/utils/extensions/view_extensions.dart';

class NameTextField extends StatelessWidget {
  const NameTextField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SizedBox(
      width: 230.w,
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        trailing: Icon(Icons.person),
        title: TextFormField(
          textCapitalization: TextCapitalization.sentences,
          style: textTheme.subtitle1,
          decoration: InputDecoration(
            hintText: "Your Name",
            hintStyle: textTheme.bodyText1!.toBlurColor(),
            contentPadding: EdgeInsets.zero,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
          ),
          initialValue: context.watch<ProfileBloc>().state.name,
          onChanged: (value) =>
              context.read<ProfileBloc>().add(NameOnChange(name: value)),
        ),
      ),
    );
  }
}
