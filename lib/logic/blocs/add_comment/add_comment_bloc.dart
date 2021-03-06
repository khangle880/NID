// 🎯 Dart imports:
import 'dart:async';
import 'dart:io';

// 📦 Package imports:
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

// 🌎 Project imports:
import '../../models/comment.dart';
import '../../repositories/firestore/comment_repository.dart';
import '../../repositories/user_repository.dart';
import '../process_state.dart';

part 'add_comment_event.dart';
part 'add_comment_state.dart';

// ignore_for_file: public_member_api_docs
class AddCommentBloc extends Bloc<AddCommentEvent, AddCommentState> {
  AddCommentBloc({required this.commentRepository, required this.userRepo})
      : super(AddCommentInitial());

  final _picker = ImagePicker();
  final CommentRepository commentRepository;

  final UserRepository userRepo;

  @override
  Stream<AddCommentState> mapEventToState(
    AddCommentEvent event,
  ) async* {
    if (event is ContentOnChange) {
      yield state.copyWith(content: event.content);
    } else if (event is ShowImagePicker) {
      yield* _mapShowImagePickerToState(event);
    } else if (event is SendComment) {
      yield* _mapSendCommentToState();
    }
  }

  Stream<AddCommentState> _mapShowImagePickerToState(
      ShowImagePicker event) async* {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage == null) return;
    final _imageFile = File(pickedImage.path);
    final String fileName = basename(_imageFile.path);
    yield state.copyWith(addStatus: Processing());

    try {
      final Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child('uploads/$fileName');
      final UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
      final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => {});
      final urlDownload = await taskSnapshot.ref.getDownloadURL();

      yield state.copyWith(addStatus: ProcessInitial(), imagePath: urlDownload);

      // final String? error = await commentRepository
      //     .updateWithJson({'avatarLink': urlDownload}, state.userInfo.id);

      // if (error == null) {
      //   print("sucess");
      //   yield state.copyWith(addStatus: ProcessSuccess());
      // } else {
      //   yield state.copyWith(addStatus: ProcessFailure(error));
      // }
    } catch (e) {
      yield state.copyWith(
        addStatus: ProcessFailure(e.toString()),
      );
      yield state.copyWith(addStatus: ProcessInitial());
    }
  }

  Stream<AddCommentState> _mapSendCommentToState() async* {
    yield state.copyWith(addStatus: Processing());
    final uid = userRepo.getUser()!.uid;
    final comment = Comment(
      id: DateTime.now().toString(),
      createdDate: DateTime.now(),
      status: true,
      content: state.content,
      creatorId: uid,
      imageLink: state.imagePath,
    );
    final String? error = await commentRepository.addObject(comment);
    if (error == null) {
      yield state.copyWith(
          addStatus: ProcessSuccess(), content: "", imagePath: "");
      yield state.copyWith(addStatus: ProcessInitial());
    } else {
      yield state.copyWith(addStatus: ProcessFailure(error));
      yield state.copyWith(addStatus: ProcessInitial());
    }
  }
}
