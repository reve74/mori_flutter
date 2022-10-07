import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:jiffy/jiffy.dart';
import 'package:mori/models/user.dart' as model;
import 'package:mori/repository/auth_repository.dart';
import 'package:mori/repository/review_repository.dart';
import 'package:mori/util/const.dart';
import 'package:mori/utils.dart';
import 'package:mori/widgets/modify_review_popup.dart';
import 'package:mori/widgets/showModalButton.dart';
import 'package:url_launcher/url_launcher.dart';

import '../util/size_helper.dart';

class ReviewCard extends StatefulWidget {
  final String movieId;
  final String movieName;
  final List blockList;
  var snap;
  ReviewCard({
    required this.movieId,
    required this.snap,
    required this.movieName,
    required this.blockList,
    Key? key,
  }) : super(key: key);

  @override
  State<ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  bool blocked = false;

  Future launchEmail(String inquireMessage) async {
    final url =
        'mailto:$EmailAdress?subject=${Uri.encodeFull(Report)}&body=${Uri.encodeFull(inquireMessage)}';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    Jiffy.locale('ko');
    print(widget.blockList);
    print(blocked);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Container(
            // height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black38,
                  blurRadius: 1.0,
                  offset: Offset(0, 0),
                  spreadRadius: 0.5,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      FutureBuilder<model.User>(
                        future: AuthRepository()
                            .futureReviewUsers(uid: widget.snap['uid']),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundImage:
                                      ExactAssetImage('assets/img/user.png'),
                                ),
                                eWidth(8),
                                Text(widget.snap['nickName'].toString()),
                                Text(
                                  '(회원 탈퇴)',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 10),
                                ),
                                Text(
                                  ' · ',
                                  style: ts,
                                ),
                                Text(
                                    Jiffy(widget.snap['datePublished'].toDate())
                                        .fromNow()),
                              ],
                            );
                            // Center(child: Text('에러가 있습니다'));
                          }
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          }
                          return Row(
                            children: [
                              snapshot.data!.profImage != ''
                                  ? CircleAvatar(
                                      radius: 20,
                                      backgroundImage: NetworkImage(
                                          snapshot.data!.profImage!),
                                    )
                                  : const CircleAvatar(
                                      radius: 20,
                                      backgroundImage: ExactAssetImage(
                                          'assets/img/user.png'),
                                    ),
                              eWidth(8),
                              Text(snapshot.data!.nickname),
                              Text(
                                ' · ',
                                style: ts,
                              ),
                              Text(Jiffy(widget.snap['datePublished'].toDate())
                                  .fromNow()),
                            ],
                          );
                          return Container();
                        },
                      ),
                      Spacer(),
                      InkWell(
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
                                  child: widget.snap['uid'] ==
                                          auth.currentUser!.uid
                                      ? Column(
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
                                                    movieId: widget.movieId
                                                        .toString(),
                                                    movie_name:
                                                        widget.movieName,
                                                    description: widget
                                                        .snap['description'],
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
                                                    movieId: widget.movieId
                                                        .toString(),
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
                                        )
                                      : Column(
                                          children: [
                                            ShowModalButton(
                                              title: '신고',
                                              onPressed: () {
                                                String inquireMessage = '제목: ${widget.movieName}\n내용: ${widget.snap['description']}\n신고내용:';
                                                Navigator.of(context).pop();
                                                launchEmail(inquireMessage);
                                              },
                                              color: Colors.white,
                                            ),
                                            widget.blockList.contains(
                                                        widget.snap['uid']) ||
                                                    blocked
                                                ? ShowModalButton(
                                                    title: '차단 해제',
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                      AuthRepository()
                                                          .blockUser(
                                                              uid: auth
                                                                  .currentUser!
                                                                  .uid,
                                                              otherUid: widget
                                                                  .snap['uid']);
                                                      setState(() {
                                                        blocked = false;
                                                        widget.blockList.remove(
                                                            widget.snap['uid']);
                                                      });
                                                    },
                                                    color: Colors.red,
                                                  )
                                                : ShowModalButton(
                                                    title: '차단',
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                      AuthRepository()
                                                          .blockUser(
                                                              uid: auth
                                                                  .currentUser!
                                                                  .uid,
                                                              otherUid: widget
                                                                  .snap['uid']);
                                                      setState(() {
                                                        blocked = true;
                                                      });
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
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  RatingBarIndicator(
                    itemSize: 25.0,
                    direction: Axis.horizontal,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.only(right: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    rating: widget.snap['star'],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      widget.blockList.contains(widget.snap['uid']) || blocked
                          ? Text('차단한 사용자 입니다')
                          : Text(widget.snap['description']),
                    ],
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
