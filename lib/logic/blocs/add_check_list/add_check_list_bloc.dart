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
import '../../models/animated_list_modal.dart';
import '../../models/check_list.dart';
import '../../repositories/firestore/quick_note_repository.dart';
import '../../repositories/user_repository.dart';
import '../../utils/extensions/logic_extensions.dart';
import '../process_state.dart';

part 'add_check_list_event.dart';
part 'add_check_list_state.dart';

/// Bloc for add a check list page
class AddCheckListBloc extends Bloc<AddCheckListEvent, AddCheckListState> {
  ///
  AddCheckListBloc({
    required this.quickNoteRepository,
    required this.userRepo,
    required AnimatedListModel<CheckItem> animatedListModel,
  }) : super(AddCheckListState(animatedListModel: animatedListModel));

  ///
  final QuickNoteRepository quickNoteRepository;

  ///
  final UserRepository userRepo;

  @override
  Stream<AddCheckListState> mapEventToState(
    AddCheckListEvent event,
  ) async* {
    if (event is TitleOnChange) {
      yield state.copyWith(title: event.title);
    } else if (event is ThemeColorOnChange) {
      yield state.copyWith(themeColor: event.themeColor);
    } else if (event is AddCheckItem) {
      state.animatedListModel.insert(event.index,
          CheckItem(description: event.description, isDone: event.isDone));
    } else if (event is RemoveCheckItem) {
      state.animatedListModel.removeAt(event.index);
    } else if (event is UpdateCheckItem) {
      final List<CheckItem> newList = List.from(state.animatedListModel.items);
      newList[event.index] = newList[event.index]
          .copyWith(isDone: event.isDone, description: event.description);
      yield state.copyWith(
          animatedListModel: state.animatedListModel.copyWith(items: newList));
    } else if (event is SubmitForm) {
      yield* _mapSubmitFormToState();
    }
  }

  Stream<AddCheckListState> _mapSubmitFormToState() async* {
    yield state.copyWith(addStatus: Processing());
    if (state.title == "") {
      yield state.copyWith(addStatus: ProcessFailure("Title can not empty"));
      yield state.copyWith(addStatus: ProcessInitial());
    } else if (!ColorConstants.kListColorPickup.contains(state.themeColor)) {
      yield state.copyWith(
          addStatus: ProcessFailure("Theme color has not been selected"));
      yield state.copyWith(addStatus: ProcessInitial());
    } else {
      final checkList = CheckList(
        id: DateTime.now().toString(),
        hexColor: state.themeColor.toHex(),
        title: state.title.simplify(),
        createdDate: DateTime.now(),
        list: state.animatedListModel.items,
        status: true,
      );
      final String? error = await quickNoteRepository.addCheckList(
          uid: userRepo.getUser()!.uid, object: checkList);

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
