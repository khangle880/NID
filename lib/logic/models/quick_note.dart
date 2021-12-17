// 🎯 Dart imports:
import 'dart:developer';

// 📦 Package imports:
import 'package:equatable/equatable.dart';

// 🌎 Project imports:
import 'check_list.dart';
import 'firestore_doc.dart';
import 'note.dart';

abstract class QuickNote extends FirestoreDoc {
  final String hexColor;
  final DateTime createdDate;
  const QuickNote(
      {required String id,
      required this.hexColor,
      required this.createdDate,
      required bool status})
      : super(id, status);

  factory QuickNote.fromJson(Map<String, dynamic> json) {
    if (json['description'] != null) return Note.fromJson(json);
    if (json['list'] != null) return CheckList.fromJson(json);
    return Note.fromJson(json);
  }
}
