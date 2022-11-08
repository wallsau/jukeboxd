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

  void setReview(String review, String objectId, String? type, String? title,
      String? artist, String? imageUrl, String? typeCollection) async {
    String userId = getUid();

    var reviewMap = <String, String>{};
    if (imageUrl!.isEmpty) {
      reviewMap = <String, String>{
        'artist': artist!,
        'title': title!,
        'review': review,
      };
    } else {
      reviewMap = <String, String>{
        'artist': artist!,
        'title': title!,
        'review': review,
        'imageUrl': imageUrl
      };
    }
    final userAndReviewMap = <String, String>{userId: review};
    final mapToAllRatings = <String, Map<dynamic, dynamic>>{
      'allReviews': userAndReviewMap
    };

    final docRef =
        db.collection('accounts').doc(userId).collection(type!).doc(objectId);
    final collectionRef = db.collection(typeCollection!).doc(objectId);
    //Update accounts document
    await docRef.set(reviewMap, SetOptions(merge: true));
    //Update albums or songs document
    await collectionRef.set(mapToAllRatings, SetOptions(merge: true));
  }

  void setRating(double rating, String objectId, String? type,
      String? typeCollection) async {
    String userId = getUid();
    final ratingMap = <String, double>{
      'rating': rating,
    };
    final userAndRatingMap = <dynamic, double>{userId: rating};
    final mapToAllRatings = <String, Map<dynamic, double>>{
      'allRatings': userAndRatingMap
    };

    final docRef =
        db.collection('accounts').doc(userId).collection(type!).doc(objectId);
    final collectionRef = db.collection(typeCollection!).doc(objectId);
    //Update accounts document
    await docRef.set(ratingMap, SetOptions(merge: true));
    //Update albums or songs document
    await collectionRef.set(mapToAllRatings, SetOptions(merge: true));
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

  void deleteReview(
      String objectId, String? type, String? collectionType) async {
    String userId = getUid();
    final deletion = <String, dynamic>{
      'rating': FieldValue.delete(),
      'review': FieldValue.delete(),
    };
    final docRef =
        db.collection('accounts').doc(userId).collection(type!).doc(objectId);
    docRef.update(deletion);
    await db.collection(collectionType!).doc(objectId).set({
      'allReviews': {userId: FieldValue.delete()}
    }, SetOptions(merge: true));
    if (await docRef.get().then((snapshot) => snapshot.data()!.isEmpty)) {
      docRef.delete();
    }
  }
}
