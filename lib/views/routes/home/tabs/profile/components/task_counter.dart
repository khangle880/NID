// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'package:nid/logic/blocs/task/get_task/task_bloc.dart';
import 'package:nid/views/utils/extensions/view_extensions.dart';

class TaskCounter extends StatelessWidget {
  const TaskCounter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final allTasks = context.watch<TaskBloc>().allDoc;
    final createdTasks = allTasks.length;
    final completedTasks = allTasks.where((element) => element.isDone).length;

    return Row(
      children: <Widget>[
        SizedBox(width: 10.w),
        SizedBox(
          width: 140.w,
          child: ListTile(
              title: Text(createdTasks.toString(), style: textTheme.subtitle1),
              subtitle:
                  Text('Create Tasks', style: textTheme.button!.toBlurColor())),
        ),
        SizedBox(width: 10.w),
        SizedBox(
          width: 150.w,
          child: ListTile(
              title:
                  Text(completedTasks.toString(), style: textTheme.subtitle1),
              subtitle: Text('Completed Tasks',
                  style: textTheme.button!.toBlurColor())),
        )
      ],
    );
  }
}
