// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// 🌎 Project imports:
import 'package:nid/logic/models/task.dart';
import 'package:nid/logic/utils/extensions/logic_extensions.dart';
import 'package:nid/views/utils/extensions/view_extensions.dart';
import 'task_item/task_item.dart';

class DayTasks extends StatefulWidget {
  const DayTasks({
    Key? key,
    required this.date,
    required this.tasksInDay,
  }) : super(key: key);

  final DateTime date;
  final List<Task> tasksInDay;
  @override
  _DayTasksState createState() => _DayTasksState();
}

class _DayTasksState extends State<DayTasks> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        SizedBox(
          height: 24.h,
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(left: 20.w),
          child: Text(
            widget.date
                .formatWithToday(newPattern: 'MMM d/yyyy', subPattern: "EEE, ")
                .toUpperCase(),
            style: textTheme.subtitle2!
                .copyWith(color: ExpandedColor.fromHex("#9A9A9A")),
            textAlign: TextAlign.start,
          ),
        ),
        SizedBox(
          height: 18.h,
        ),
        ListView.builder(
          itemCount: widget.tasksInDay.length,
          itemBuilder: (context, index) {
            return TaskItem(
              task: widget.tasksInDay[index],
            );
          },
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
        ),
      ],
    );
  }
}
