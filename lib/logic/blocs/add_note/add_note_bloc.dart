// 🎯 Dart imports:
import 'dart:async';

// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

// 🌎 Project imports:
import '../../../global/constants/app_constants.dart';
import '../../../views/utils/extensions/view_extensions.dart';
import '../../models/note.dart';
import '../../repositories/firestore/quick_note_repository.dart';
import '../../repositories/user_repository.dart';
import '../../utils/extensions/logic_extensions.dart';
import '../process_state.dart';

part 'add_note_event.dart';
part 'add_note_state.dart';

class AddNoteBloc extends Bloc<AddNoteEvent, AddNoteState> {
  AddNoteBloc({required this.quickNoteRepository, required this.userRepo})
      : super(AddNoteState());

  final QuickNoteRepository quickNoteRepository;
  final UserRepository userRepo;

  @override
  Stream<AddNoteState> mapEventToState(
    AddNoteEvent event,
  ) async* {
    if (event is DescriptionOnChange) {
      yield state.copyWith(description: event.description);
    } else if (event is ThemeColorOnChange) {
      yield state.copyWith(themeColor: event.themeColor);
    } else if (event is SubmitForm) {
      yield* _mapSubmitFormToState();
    }
  }

  Stream<AddNoteState> _mapSubmitFormToState() async* {
    yield state.copyWith(addStatus: Processing());
    if (state.description == "") {
      yield state.copyWith(
          addStatus: ProcessFailure("Description can not empty"));
      yield state.copyWith(addStatus: ProcessInitial());
    } else if (!ColorConstants.kListColorPickup.contains(state.themeColor)) {
      yield state.copyWith(
          addStatus: ProcessFailure("Theme color has not been selected"));
      yield state.copyWith(addStatus: ProcessInitial());
    } else {
      final note = Note(
        id: DateTime.now().toString(),
        hexColor: state.themeColor.toHex(),
        description: state.description.simplify(),
        createdDate: DateTime.now(),
        status: true,
      );
      final String? error = await quickNoteRepository.addNote(
          uid: userRepo.getUser()!.uid, object: note);
      if (error == null) {
        yield state.copyWith(addStatus: ProcessSuccess());
        yield state.copyWith(addStatus: ProcessInitial());
      } else {
        yield state.copyWith(addStatus: ProcessFailure(error));
        yield state.copyWith(addStatus: ProcessInitial());
      }
    }
  }
}
