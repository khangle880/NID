import 'dart:async';

import '../../firestore/firestore_bloc.dart';
import '../../process_state.dart';
import '../../../models/task.dart';
import '../../../repositories/firestore/task_repository.dart';
import '../../../utils/extensions/logic_extensions.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends FirestoreBloc<Task> {
  TaskBloc(TaskRepository taskRepository) : super(taskRepository);

  String? currentTask;

  @override
  Stream<FirestoreState<Task>> mapMoreEventToState(
    FirestoreEvent event,
  ) async* {
    if (event is FilterByStatusTasks) {
      yield* _mapFilterByStatusTasksToState(event.optionFilter);
    } else if (event is ViewTask) {
      currentTask = event.id;
    }
  }

  Stream<FirestoreState<Task>> _mapFilterByStatusTasksToState(
      OptionTaskStatusFilter optionFilter) async* {
    if (state is FirestoreLoaded<Task>) {
      final tasks = TaskList(allDoc).filterByStatus(option: optionFilter);
      yield TaskFiltered(optionFilter, tasks);
    }
  }
}
