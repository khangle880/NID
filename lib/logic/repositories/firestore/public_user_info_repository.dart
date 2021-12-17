// 📦 Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';

// 🌎 Project imports:
import '../../models/public_user_info.dart';
import 'base_firestore_repository.dart';

class PublicUserInfoRepository extends FirestoreRepository<PublicUserInfo> {
  PublicUserInfoRepository({
    FirebaseFirestore? firebaseFirestore,
  }) : super(
          firebaseFirestore: firebaseFirestore,
          collectionRef: (firebaseFirestore ?? FirebaseFirestore.instance)
              .collection('public_users_info'),
        );

  @override
  Stream<List<PublicUserInfo>> getAllDoc(String uid) {
    return firebaseFirestore
        .collection('public_users_info')
        .where("status", isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              data['id'] = doc.id;
              return PublicUserInfo.fromJson(data);
            }).toList());
  }
}
