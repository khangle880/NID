// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// 🌎 Project imports:
import 'package:nid/logic/blocs/firestore/firestore_bloc.dart';
import 'package:nid/logic/blocs/task/get_task/task_bloc.dart';
import 'package:nid/logic/models/check_list.dart';
import 'package:nid/logic/models/note.dart';
import 'package:nid/logic/models/quick_note.dart';
import 'package:nid/logic/models/task.dart';
import 'package:nid/views/utils/extensions/view_extensions.dart';
import 'package:nid/views/widgets/circular_border.dart';

class WorkListStatistic extends StatelessWidget {
  const WorkListStatistic({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final List<Task> allTasks = context.watch<TaskBloc>().allDoc;
    final List<QuickNote> allQuickNotes =
        context.watch<FirestoreBloc<QuickNote>>().allDoc;

    final events = allTasks.where((e) => e.dueDate != null);
    final eventPercent = (events.length == 0)
        ? 100
        : (events.where((e) => e.isDone).length / events.length * 100).round();

    final todo = allTasks.where((e) => e.dueDate == null);
    final todoPercent = (todo.length == 0)
        ? 100
        : (todo.where((e) => e.isDone).length / todo.length * 100).round();

    final quickNotePercent = (allQuickNotes.length == 0)
        ? 100
        : (allQuickNotes.where((e) {
                  if (e is Note) {
                    return true;
                  } else {
                    return (e as CheckList)
                        .list
                        .where((element) => element.isDone)
                        .isNotEmpty;
                  }
                }).length /
                allQuickNotes.length *
                100)
            .round();

    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Statistic", style: textTheme.subtitle1),
          SizedBox(height: 21.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StatisticItem(
                percent: eventPercent,
                title: 'Events',
                color: ExpandedColor.fromHex("#F96969"),
              ),
              StatisticItem(
                percent: todoPercent,
                title: 'To do',
                color: ExpandedColor.fromHex("#6074F9"),
              ),
              StatisticItem(
                percent: quickNotePercent,
                title: 'Quick Notes',
                color: ExpandedColor.fromHex("#8560F9"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class StatisticItem extends StatelessWidget {
  const StatisticItem({
    Key? key,
    required this.title,
    required this.percent,
    required this.color,
  }) : super(key: key);

  final String title;
  final int percent;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        CircularBorder(
          strokeWidth: 2,
          size: 80.h,
          color: color,
          backgroudColor: ExpandedColor.fromHex("#E8E8E8"),
          offsetDot: 6,
          ratioDot: 2,
          child: Text(
            "$percent%",
            style: textTheme.subtitle1,
          ),
        ),
        SizedBox(height: 14.h),
        Text(title, style: textTheme.button),
      ],
    );
  }
}
