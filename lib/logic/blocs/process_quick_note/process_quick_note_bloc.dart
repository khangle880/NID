import 'dart:async';

import '../process_firestore_doc/process_firestore_doc_bloc.dart';
import '../process_state.dart';
import '../../models/check_list.dart';
import '../../models/quick_note.dart';
import '../../repositories/firestore/base_firestore_repository.dart';
import '../../repositories/firestore/quick_note_repository.dart';

part 'process_quick_note_event.dart';

class ProcessQuickNoteBloc extends ProcessFSDocBloc<QuickNote> {
  ProcessQuickNoteBloc(FirestoreRepository<QuickNote> firestoreRepository)
      : super(firestoreRepository);

  @override
  Stream<ProcessState> mapMoreEventToState(
    ProcessFSDocEvent event,
  ) async* {
    if (event is UpdateCLItemCompleteStatus) {
      final newList = event.checkList.list
          .map((e) => e != event.checkItem
              ? e.toJson()
              : CheckItem(
                      description: e.description, isDone: event.completeStatus)
                  .toJson())
          .toList();
      yield* mapProcessToState(
          (firestoreRepository as QuickNoteRepository).updateCheckListWithJson(
        json: {'list': newList},
        uid: event.uid,
        docId: event.checkList.id,
      ));
    }
  }
}
