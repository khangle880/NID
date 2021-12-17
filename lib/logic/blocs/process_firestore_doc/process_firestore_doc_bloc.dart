// 🎯 Dart imports:
import 'dart:async';
import 'dart:developer';

// 📦 Package imports:
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

// 🌎 Project imports:
import '../../models/firestore_doc.dart';
import '../../repositories/firestore/base_firestore_repository.dart';
import '../process_state.dart';

part 'process_firestore_doc_event.dart';

class ProcessFSDocBloc<T extends FirestoreDoc>
    extends Bloc<ProcessFSDocEvent<T>, ProcessState> {
  ProcessFSDocBloc(this.firestoreRepository) : super(ProcessInitial());
  final FirestoreRepository<T> firestoreRepository;

  @override
  Stream<ProcessState> mapEventToState(
    ProcessFSDocEvent<T> event,
  ) async* {
    if (event is UpdateFSDocByObject<T>) {
      yield* mapProcessToState(
          firestoreRepository.updateByObject(event.object));
    } else if (event is UpdateFSDocByJson<T>) {
      yield* mapProcessToState(
          firestoreRepository.updateWithJson(event.json, event.docId));
    } else if (event is DeleteFSDoc<T>) {
      yield* mapProcessToState(firestoreRepository.deleteObject(event.docId));
    } else {
      yield* mapMoreEventToState(event);
    }
  }

  Stream<ProcessState> mapMoreEventToState(ProcessFSDocEvent event) async* {}

  Stream<ProcessState> mapProcessToState(Future<String?> onProcess) async* {
    yield Processing();
    log('processing');
    final String? error = await onProcess;
    if (error == null) {
      yield ProcessSuccess();
      yield ProcessInitial();
    } else {
      yield ProcessFailure(error);
      yield ProcessInitial();
    }
  }
}
