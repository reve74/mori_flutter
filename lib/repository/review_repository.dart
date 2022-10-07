import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mori/models/movie_details.dart';
import 'package:mori/models/review.dart';
import 'package:mori/util/const.dart';

class ReviewRepository {
  // 리뷰 업로드
  Future<void> uploadReview({
    required String movieId,
    required String uid,
    required String description,
    required String nickName,
    required double star,
    required String poster_path,
    required String movie_name,
  }) async {
    try {
      Review review = Review(
        description: description,
        uid: uid,
        datePublished: DateTime.now(),
        star: star,
        id: int.parse(movieId),
        poster_path: poster_path,
        movie_name: movie_name,
        nickName: nickName,
      );

      await firebaseFirestore
          .collection('review')
          .doc(movieId)
          .collection('reviewList')
          .doc(uid)
          .set(review.toJson());
      // .add(review.toJson());

      await firebaseFirestore
          .collection('myReview')
          .doc(uid)
          .collection('reviewList')
          .doc(movieId)
          .set(review.toJson());

      print('upload');
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> modifyReview({
    required String movieId,
    required String uid,
    required String description,
    required double star,
  }) async {
    try {
      // Review review = Review(
      //   description: description,
      //   uid: uid,
      //   datePublished: DateTime.now(),
      //   star: star,
      //   id: int.parse(movieId),
      // );

      await firebaseFirestore
          .collection('review')
          .doc(movieId)
          .collection('reviewList')
          .doc(uid)
          .update({
        'description': description,
        'star': star,
      });
      // .add(review.toJson());

      await firebaseFirestore
          .collection('myReview')
          .doc(uid)
          .collection('reviewList')
          .doc(movieId)
          .update({
        'description': description,
        'star': star,
      });

      print('수정');
    } catch (e) {
      print(e.toString());
    }
  }

  // 리뷰 삭제
  Future<void> deleteReview(
      {required String movieId, required String uid}) async {
    await firebaseFirestore
        .collection('review')
        .doc(movieId)
        .collection('reviewList')
        .doc(uid)
        .delete();

    await firebaseFirestore
        .collection('myReview')
        .doc(uid)
        .collection('reviewList')
        .doc(movieId)
        .delete();
  }

  Future<QuerySnapshot> futureGetReview({required String movieId}) {
    print('success');
    return firebaseFirestore
        .collection('review')
        .doc(movieId)
        .collection('reviewList')
        .orderBy('datePublished', descending: true)
        .get();
  }

  Stream<QuerySnapshot> streamGetReview({required String movieId}) {
    return firebaseFirestore
        .collection('review')
        .doc(movieId)
        .collection('reviewList')
        .orderBy('datePublished', descending: true)
        .snapshots();
  }

  Stream streamMyReview() {
    return firebaseFirestore
        .collection('myReview')
        .doc(auth.currentUser!.uid)
        .collection('reviewList')
        .snapshots();
  }
}
