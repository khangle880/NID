// 📦 Package imports:
import 'package:bloc/bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

// 🌎 Project imports:
import '../../models/task.dart';
import '../../utils/extensions/logic_extensions.dart';

enum WorkListState {
  processing,
  grouped,
}

class WorkListCubit extends Cubit<WorkListState> {
  WorkListCubit({required this.tasks}) : super(WorkListState.processing);

  final List<Task> tasks;
  Map<DateTime, List<Task>> tasksByDate = {};
  final SlidableController slidableController = SlidableController();

  void groupByDate() {
    emit(WorkListState.processing);
    tasksByDate = tasks.groupAndSortByTime();
    emit(WorkListState.grouped);
  }

  void filterByProject(String projectId) {
    emit(WorkListState.processing);
    tasksByDate = tasks
        .where((element) => element.projectId == projectId)
        .toList()
        .groupAndSortByTime();
    emit(WorkListState.grouped);
  }
}
