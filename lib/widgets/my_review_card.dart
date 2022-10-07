import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:mori/repository/review_repository.dart';
import 'package:mori/screen/movie_details_screen.dart';
import 'package:mori/util/size_helper.dart';
import 'package:mori/utils.dart';
import 'package:mori/widgets/modify_review_popup.dart';
import 'package:mori/widgets/showModalButton.dart';

import '../util/const.dart';

class MyReviewCard extends StatelessWidget {
  final String movieId;
  final String poster;
  final String movieName;
  final double star;
  final DateTime date;
  final String description;
  final bool expand;

  const MyReviewCard({
    required this.movieId,
    required this.poster,
    required this.movieName,
    required this.star,
    required this.date,
    required this.description,
    required this.expand,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Jiffy.locale('ko');

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        color: Colors.grey.shade800,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 80,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            MovieDetailsScreen(id: int.parse(movieId))));
                  },
                  child: Row(
                    children: [
                      ClipRRect(
                        child: Image.network(
                          poster,
                          width: 60,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      eWidth(8),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            movieName,
                            style: const TextStyle(fontSize: 14.0),
                          ),
                          eHeight(5),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade700),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Row(
                                children: [
                                  const Text(
                                    '내 평가  · ',
                                    style: TextStyle(fontSize: 13),
                                  ),
                                  const Icon(
                                    Icons.star,
                                    size: 14.0,
                                  ),
                                  Text(
                                    star.toDouble().toString(),
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Text(
                            Jiffy(date).fromNow(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Divider(height: 1),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    description,
                    style: TextStyle(fontSize: 13),
                  ),
                  if (expand == true)
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {
                        ReviewRepository().deleteReview(
                            movieId: movieId, uid: auth.currentUser!.uid);
                        showSnackBar('리뷰를 삭제하였습니다!', context);
                      },
                      child: InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(25.0),
                              ),
                            ),
                            builder: (BuildContext ctx) {
                              return Container(
                                  height:
                                      MediaQuery.of(context).size.height * .2,
                                  child: Column(
                                    children: [
                                      ShowModalButton(
                                        title: '수정',
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (context) =>
                                                ModifyReviewPopup(
                                              movieId: movieId.toString(),
                                              movie_name: movieName,
                                              description: description,
                                            ),
                                          );
                                        },
                                        color: Colors.white,
                                      ),
                                      ShowModalButton(
                                        title: '삭제',
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          ReviewRepository().deleteReview(
                                              movieId: movieId.toString(),
                                              uid: auth.currentUser!.uid);
                                        },
                                        color: Colors.red,
                                      ),
                                      ShowModalButton(
                                        title: '취소',
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        color: Colors.white,
                                      ),
                                    ],
                                  ));
                            },
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            'assets/icon/kebab.png',
                            width: 15,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
