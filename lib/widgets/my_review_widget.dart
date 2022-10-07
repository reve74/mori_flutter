import 'package:flutter/material.dart';
import 'package:mori/models/movie_details.dart';
import 'package:mori/repository/movie_repository.dart';
import 'package:mori/repository/review_repository.dart';
import 'package:mori/screen/my_review.dart';
import 'package:mori/util/size_helper.dart';

class MyReviewWidget extends StatelessWidget {
  const MyReviewWidget({Key? key}) : super(key: key);

  Widget myReviewCard(String postUrl, BuildContext context) {
    return Container(
      // height: 120,
      // color: Colors.black,
      // child: CircleAvatar(
      //   maxRadius: 55,
      //   backgroundImage: NetworkImage(postUrl),
        child: Image.network(
          postUrl,
          height: 110,
          fit: BoxFit.cover,
        // ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text('내 리뷰'),
        ),
        eHeight(5),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => MyReview()));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              height: 150,
              decoration: BoxDecoration(
                color: Color(0xff293462),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 150,
                    child: Row(
                      children: [
                        StreamBuilder(
                          stream: ReviewRepository().streamMyReview(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.active) {
                              if (snapshot.hasData) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      child: Row(
                                        children: List.generate(
                                          (snapshot.data as dynamic)
                                              .docs
                                              .length,
                                          (index) {
                                            var movieId =
                                                (snapshot.data as dynamic)
                                                    .docs[index]
                                                    .data()['id'];
                                            return FutureBuilder<MovieDetails>(
                                              future: MovieRepository()
                                                  .getMovieDetails(id: movieId),
                                              builder: (context, snapshot) {
                                                if (snapshot.hasError) {
                                                  return const Text('에러가 있습니다');
                                                }
                                                if (!snapshot.hasData) {
                                                  return const Center(
                                                      child:
                                                          CircularProgressIndicator());
                                                }
                                                return myReviewCard(
                                                    snapshot.data!.postUrl,
                                                    context);
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(5),
                                      height: 30,
                                      child: Text(
                                          '리뷰${(snapshot.data as dynamic).docs.length}개'),
                                    ),
                                  ],
                                );
                              }
                              if (snapshot.hasError) {
                                const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            }
                            return Container();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
