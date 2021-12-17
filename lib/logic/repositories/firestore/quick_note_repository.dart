// 🎯 Dart imports:
import 'dart:async';
import 'dart:developer';

// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

// 🌎 Project imports:
import '../../models/check_list.dart';
import '../../models/note.dart';
import '../../models/quick_note.dart';
import 'base_firestore_repository.dart';

class QuickNoteRepository extends FirestoreRepository<QuickNote> {
  QuickNoteRepository({
    FirebaseFirestore? firebaseFirestore,
  }) : super(
            firebaseFirestore: firebaseFirestore,
            collectionRef: (firebaseFirestore ?? FirebaseFirestore.instance)
                .collection('users'));

  @override
  Stream<List<QuickNote>> getAllDoc(String uid) {
    final userRef = collectionRef.doc(uid);
    final stream1 = userRef
        .collection('note')
        .orderBy('createdDate', descending: false)
        .snapshots();
    final stream2 = userRef.collection('check_list').snapshots();

    return CombineLatestStream.combine2(stream1, stream2,
        (QuerySnapshot<Map<String, dynamic>> a,
            QuerySnapshot<Map<String, dynamic>> b) {
      final docs = a.docs + b.docs;
      final mapedData = docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return QuickNote.fromJson(data);
      }).toList();
      return mapedData;
    });
  }

  Future<String?> updateCheckListWithJson({
    required Map<String, dynamic> json,
    required String docId,
    required String uid,
  }) {
    return handleWriteData(collectionRef
        .doc(uid)
        .collection('check_list')
        .doc(docId)
        .update(json));
  }

  Future<String?> updateNoteWithJson({
    required Map<String, dynamic> json,
    required String docId,
    required String uid,
  }) {
    return handleWriteData(
        collectionRef.doc(uid).collection('note').doc(docId).update(json));
  }

  Future<String?> addCheckList({
    required CheckList object,
    required String uid,
  }) {
    return handleWriteData(
        collectionRef.doc(uid).collection('check_list').add(object.toJson()));
  }

  Future<String?> addNote({
    required Note object,
    required String uid,
  }) {
    return handleWriteData(
        collectionRef.doc(uid).collection('note').add(object.toJson()));
  }
}
