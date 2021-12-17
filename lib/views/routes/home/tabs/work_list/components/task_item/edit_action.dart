import 'package:nid/logic/blocs/task/get_task/task_bloc.dart';
import 'package:nid/logic/blocs/task/process_task/process_task_bloc.dart';
import 'package:nid/logic/models/task.dart';
import 'package:nid/routing/app_routes.dart';
import 'package:nid/routing/routes.dart';
import 'package:nid/views/utils/extensions/view_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class EditAction extends StatelessWidget {
  const EditAction({
    Key? key,
    required this.task,
  }) : super(key: key);

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            width: 1.w,
            color: Colors.black.withOpacity(0.1),
          ),
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(5.w, 5.w),
            color: Color.fromRGBO(224, 224, 224, 0.5),
            blurRadius: 9.w,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 3.w),
        child: IconSlideAction(
          color: Colors.white,
          iconWidget: Icon(Icons.edit_outlined,
              color: ExpandedColor.fromHex("#F96060")),
          onTap: () {
            context.read<TaskBloc>().add(ViewTask(id: task.id));
            AppRoutes.mainNav.currentState!.pushNamed(
                MainRouteNames.viewTaskDetailsRoute,
                arguments: context.read<ProcessTaskBloc>());
          },
        ),
      ),
    );
  }
}
