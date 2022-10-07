import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mori/screen/my_review_screen.dart';
import 'package:mori/util/const.dart';
import 'package:mori/widgets/my_review_card.dart';

class MyReview extends StatelessWidget {
  MyReview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
              return Center(child: CircularProgressIndicator());
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                    height: 30,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '리뷰 ${(snapshot.data as dynamic).docs.length.toString()}',
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                        (snapshot.data as dynamic).docs.length != 0
                            ? TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => MyReviewScreen(
                                        count: (snapshot.data as dynamic).docs.length,
                                      )));
                                },
                                child: const Text(
                                  '모두 보기',
                                  style: TextStyle(
                                    color: Colors.blue,
                                  ),
                                ),
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                ),
                              )
                            : Container(),
                        // Text(
                        //     '${(snapshot.data as dynamic).docs.length.toString()}개의 리뷰'),
                      ],
                    ),
                  ),
                ),
                ...writeList(snapshot),
                if ((snapshot.data as dynamic).docs.length == 0)
                  Container(
                    height: 100,
                    child: const Center(
                      child: Text('작성한 리뷰가 없습니다!'),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  List writeList(AsyncSnapshot<QuerySnapshot> snapshot) {
    return List.generate((snapshot.data as dynamic).docs.length, (index) {
      // print((snapshot.data as dynamic).docs.length);
      if ((snapshot.data as dynamic).docs.length == 0) {
        return Container(
          height: 50,
          child: const Center(
            child: Text('작성한 리뷰가 없습니다!'),
          ),
        );
      } else {
        if (index > 2) {
          return Container();
        }
        return reviewCount(doc: snapshot.data!.docs[index]);
      }
    });
  }

  reviewCount({required QueryDocumentSnapshot doc}) {
    return MyReviewCard(
      movieId: doc['id'].toString(),
      poster: doc['poster_path'],
      movieName: doc['movie_name'],
      star: doc['star'],
      date: doc['datePublished'].toDate(),
      description: doc['description'],
      expand: false,
    );
  }
}
