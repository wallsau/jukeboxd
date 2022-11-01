import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DataBase {
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  String getUid() {
    final user = auth.currentUser;
    final uid = user!.uid;
    return uid;
  }

  void setReview(String review, String objectId, String? type) async {
    String userId = getUid();
    final reviewMap = <String, String>{
      'review': review,
    };
    final docRef =
        db.collection('accounts').doc(userId).collection(type!).doc(objectId);
    await docRef.set(reviewMap, SetOptions(merge: true));
  }

  void setRating(double rating, String objectId, String? type) async {
    String userId = getUid();
    final reviewMap = <String, double>{
      'rating': rating,
    };
    final docRef =
        db.collection('accounts').doc(userId).collection(type!).doc(objectId);
    await docRef.set(reviewMap, SetOptions(merge: true));
  }

  double getRating(String objectId, String? type) {
    String userId = getUid();
    double rating = 0.0;
    var map = <String, dynamic>{
      'rating': 0.0,
      'review': '',
    };
    final docRef =
        db.collection('accounts').doc(userId).collection(type!).doc(objectId);

    docRef.get().then((snapshot) =>
        snapshot.data()!.containsKey('rating') ? map = snapshot.data()! : map);

    rating = map['rating'];
    return rating;
  }

  void deleteReview(String objectId, String? type) async {
    String userId = getUid();
    final deletion = <String, dynamic>{
      'rating': FieldValue.delete(),
      'review': FieldValue.delete(),
    };
    final docRef =
        db.collection('accounts').doc(userId).collection(type!).doc(objectId);
    docRef.update(deletion);

    if (await docRef.get().then((snapshot) => snapshot.data()!.isEmpty)) {
      docRef.delete();
    }
  }
}
