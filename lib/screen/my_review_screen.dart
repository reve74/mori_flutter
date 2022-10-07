import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mori/screen/bottom_navigation.dart';
import 'package:mori/screen/my_review.dart';
import 'package:mori/widgets/my_review_card.dart';

import '../util/const.dart';

class MyReviewScreen extends StatelessWidget {
  // final QueryDocumentSnapshot doc;
  final int count;
  const MyReviewScreen({
    required this.count,
    // required this.doc,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내가 쓴 리뷰'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder(
              stream: firebaseFirestore
                  .collection('myReview')
                  .doc(auth.currentUser!.uid)
                  .collection('reviewList')
                  .orderBy('datePublished', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: const CircularProgressIndicator());
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                      child: Text(
                        '리뷰 ${(snapshot.data as dynamic).docs.length.toString()}개',
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                    ),
                    ...List.generate(
                      (snapshot.data as dynamic).docs.length,
                      (index) {
                        DocumentSnapshot doc = snapshot.data!.docs[index];
                        return MyReviewCard(
                          movieId: doc['id'].toString(),
                          poster: doc['poster_path'],
                          movieName: doc['movie_name'],
                          star: doc['star'],
                          date: doc['datePublished'].toDate(),
                          description: doc['description'],
                          expand: true,
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
