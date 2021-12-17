// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

// 🌎 Project imports:
import 'package:nid/logic/blocs/process_firestore_doc/process_firestore_doc_bloc.dart';
import 'package:nid/logic/blocs/task/process_task/process_task_bloc.dart';
import 'package:nid/logic/models/task.dart';
import 'package:nid/views/utils/extensions/view_extensions.dart';

class DeleteAction extends StatelessWidget {
  const DeleteAction({
    Key? key,
    required this.task,
  }) : super(key: key);

  final Task task;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
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
          iconWidget: Icon(Icons.delete_outline,
              color: ExpandedColor.fromHex("#F96060")),
          onTap: () {
            context
                .read<ProcessTaskBloc>()
                .add(DeleteFSDoc<Task>(docId: task.id));
          },
        ),
      ),
    );
  }
}
