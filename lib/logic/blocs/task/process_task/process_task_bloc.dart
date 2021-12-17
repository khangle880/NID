import 'dart:async';

import '../../process_firestore_doc/process_firestore_doc_bloc.dart';
import '../../process_state.dart';
import '../../../models/task.dart';
import '../../../repositories/firestore/base_firestore_repository.dart';
import '../../../repositories/firestore/task_repository.dart';

part 'process_task_event.dart';

class ProcessTaskBloc extends ProcessFSDocBloc<Task> {
  ProcessTaskBloc(FirestoreRepository<Task> firestoreRepository)
      : super(firestoreRepository);

  @override
  Stream<ProcessState> mapMoreEventToState(
    ProcessFSDocEvent event,
  ) async* {
    if (event is UpdateCompleteStatus) {
      yield* _mapUpdateCompleteStatusToState(event.completeStatus, event.id);
    }
  }

  Stream<ProcessState> _mapUpdateCompleteStatusToState(
      bool completeStatus, String id) async* {
    yield* mapProcessToState((firestoreRepository as TaskRepository)
        .updateWithJson({'isDone': completeStatus}, id));
  }
}
