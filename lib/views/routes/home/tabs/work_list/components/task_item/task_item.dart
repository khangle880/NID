// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

// 🌎 Project imports:
import 'package:nid/logic/blocs/process_state.dart';
import 'package:nid/logic/blocs/task/process_task/process_task_bloc.dart';
import 'package:nid/logic/cubits/work_list/work_list_cubit.dart';
import 'package:nid/logic/models/task.dart';
import 'package:nid/logic/repositories/firestore/task_repository.dart';
import 'package:nid/views/utils/extensions/flush_bar.dart';
import 'delete_action.dart';
import 'edit_action.dart';
import 'item_body.dart';

class TaskItem extends StatelessWidget {
  const TaskItem({Key? key, required this.task}) : super(key: key);

  final Task task;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProcessTaskBloc>(
      create: (_) => ProcessTaskBloc(context.read<TaskRepository>()),
      child: BlocListener<ProcessTaskBloc, ProcessState>(
        listener: (context, state) {
          if (state is Processing) {
            ExpandedFlushbar.loadingFlushbar(context, message: "Updating")
                .show(context);
          }
          if (state is ProcessFailure) {
            ExpandedFlushbar.failureFlushbar(context,
                    message: state.errorMessage)
                .show(context);
          }
          if (state is ProcessSuccess) {
            ExpandedFlushbar.successFlushbar(context,
                    message: 'Update Successfully!')
                .show(context);
          }
        },
        child: Slidable(
          controller: context.read<WorkListCubit>().slidableController,
          actionPane: SlidableDrawerActionPane(),
          showAllActionsThreshold: 0.4,
          actionExtentRatio: 0.2,
          secondaryActions: [
            EditAction(task: task),
            DeleteAction(task: task),
          ],
          child: ItemBody(task: task),
        ),
      ),
    );
  }
}
