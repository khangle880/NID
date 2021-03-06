// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

// 🌎 Project imports:
import 'package:nid/global/constants/assets_path.dart';
import 'package:nid/logic/blocs/task/get_task/task_bloc.dart';
import 'package:nid/logic/blocs/task/process_task/process_task_bloc.dart';
import 'package:nid/logic/utils/extensions/logic_extensions.dart';
import 'package:nid/views/routes/home/tabs/work_list/view_task_details/components/more_detail_body.dart';
import 'package:nid/views/routes/home/tabs/work_list/view_task_details/components/project_row.dart';
import 'package:nid/views/utils/extensions/flush_bar.dart';
import 'package:nid/views/utils/extensions/view_extensions.dart';
import 'package:nid/views/widgets/empty_view.dart';
import 'package:nid/views/widgets/rounded_button.dart';
import 'assigned_to_row.dart';
import 'description_row.dart';
import 'due_date_row.dart';
import 'members_row.dart';

class TaskDetailsBody extends StatelessWidget {
  const TaskDetailsBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final taskBloc = context.watch<TaskBloc>();
    final idTask = taskBloc.currentTask;

    if (idTask == null) return EmptyView();
    final task = taskBloc.allDoc.findById(idTask);
    if (task == null) return EmptyView();
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.h),
      height: 660.h,
      child: ListView(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        children: [
          Text(task.title, style: textTheme.subtitle1),
          SizedBox(height: 25.h),
          AssignedToRow(assignedToId: task.assignedToId),
          Divider(
            color: ExpandedColor.fromHex("#E4E4E4"),
            height: 40.h,
            thickness: 1.h,
          ),
          DueDateRow(dueDate: task.dueDate),
          Divider(
            color: ExpandedColor.fromHex("#E4E4E4"),
            height: 40.h,
            thickness: 1.h,
          ),
          DescriptionRow(description: task.description),
          Divider(
            color: ExpandedColor.fromHex("#E4E4E4"),
            height: 40.h,
            thickness: 1.h,
          ),
          MembersRow(members: task.members),
          Divider(
            color: ExpandedColor.fromHex("#E4E4E4"),
            height: 40.h,
            thickness: 1.h,
          ),
          ProjectRow(project: task.projectId),
          SizedBox(height: 32.h),
          MoreDetailBody(task: task),
        ],
      ),
    );
  }
}
