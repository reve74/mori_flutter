import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mori/models/movie_details.dart';
import 'package:mori/repository/movie_repository.dart';
import 'package:mori/repository/review_repository.dart';
import 'package:mori/util/const.dart';
import 'package:mori/util/size_helper.dart';
import 'package:mori/utils.dart';
import 'package:mori/widgets/genres_card.dart';
import 'package:mori/widgets/details_appbar.dart';
import 'package:mori/widgets/recommend_card.dart';
import 'package:mori/widgets/review_card.dart';
import 'package:mori/widgets/trailer_widget.dart';
import 'package:mori/widgets/write_review_popup.dart';

class MovieDetailsScreen extends StatefulWidget {
  final int id;

  const MovieDetailsScreen({
    required this.id,
    Key? key,
  }) : super(key: key);

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  bool _isLoading = false;
  bool likes = false;
  bool isExpanded = true;
  ScrollController scrollController = ScrollController();
  String nickName = '';
  String profImage = '';
  List reviewList = [];
  List blockList = [];

  @override
  initState() {
    super.initState();
    getData();
    scrollController.addListener(scrollListener);
  }

  Future<void> getReview(int id) async {
    try {
      ReviewRepository().futureGetReview(movieId: id.toString());
    } catch (e) {
      print(e.toString());
    }
  }

  void getData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      var userSnap = await firebaseFirestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .get();
      // nickName = userSnap.data()!['nickname'];
      // profImage = userSnap.data()!['profImage'];
      likes = userSnap.data()!['likes'].contains(widget.id.toString());
      blockList = userSnap.data()!['block'];
      print(blockList);

      setState(() {});
    } catch (e) {
      print(e.toString());
    }
    setState(() {
      _isLoading = false;
    });
  }

  scrollListener() {
    bool isExpanded = scrollController.offset < 500 - kToolbarHeight;
    if (isExpanded != this.isExpanded) {
      setState(() {
        this.isExpanded = isExpanded;
      });
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: likeBtn(),
      body: FutureBuilder<MovieDetails>(
        future: MovieRepository().getMovieDetails(id: widget.id),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return const Center(child: Text('에러가 있습니다'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          MovieDetails md = snapshot.data!;
          return SafeArea(
            top: false,
            child: GestureDetector(
              onTap: FocusScope.of(context).unfocus,
              child: CustomScrollView(
                controller: scrollController,
                slivers: [
                  DetailsAppBar(
                    title: md.title,
                    poster_Path: md.poster_path.isNotEmpty
                        ? (Poster + '${md.postUrl}')
                        : '',
                    isExpanded: isExpanded,
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            children: [
                              topInfo(md),
                              Column(
                                children: [
                                  description(md),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // recommendListAndReview(md),
                        trailerAndRecommendTitle(md),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // FloatingActionButton
  Widget likeBtn() {
    return CircleAvatar(
      radius: 30,
      backgroundColor: Colors.indigo.shade600,
      child: likes
          ? IconButton(
              onPressed: () async {
                await MovieRepository().likeMovies(
                    uid: auth.currentUser!.uid, movieId: widget.id.toString());
                setState(() {
                  likes = false;
                });
                // showSnackBar('찜 리스트에서 삭제되었습니다!', context);
              },
              icon: const Icon(
                Icons.favorite,
                color: Colors.red,
                size: 30,
              ),
            )
          : IconButton(
              onPressed: () async {
                await MovieRepository().likeMovies(
                    uid: auth.currentUser!.uid, movieId: widget.id.toString());
                setState(() {
                  likes = true;
                });
                // showSnackBar('찜 리스트에 추가하였습니다!', context);
              },
              icon: const Icon(
                Icons.favorite_border_rounded,
                size: 30,
              ),
            ),
    );
  }

  Widget topInfo(MovieDetails md) {
    return Column(
      children: [
        eHeight(10),
        Align(
          alignment: Alignment.center,
          child: Text(
            md.title,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            md.release_date.isNotEmpty
                ? Text(
                    '개봉 : ${DateFormat('y/MM/dd').format(DateTime.parse(md.release_date))}',
                    style: ts,
                  )
                : Container(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                '·',
                style: ts,
              ),
            ),
            Text(
              '${md.runtime.toString()}분',
              style: ts,
            ),
          ],
        ),
        eHeight(10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...List.generate(
              md.genres.length,
              (index) => GenresCard(
                genres: md.genres[index]['name'].toString(),
              ),
            ),
          ],
        ),
        eHeight(10),
      ],
    );
  }

  Widget description(MovieDetails md) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        md.tagline.isNotEmpty
            ? Text(
                md.tagline,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey.shade500,
                  fontStyle: FontStyle.italic,
                ),
              )
            : Container(),
        eHeight(10),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            '개요',
            style: titleStyle,
          ),
        ),
        Text(
          md.overview,
          style: const TextStyle(fontSize: 18),
        ),
        eHeight(10),
      ],
    );
  }

  Widget trailerAndRecommendTitle(MovieDetails md) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TrailerWidget(movieId: md.id.toString()),
              eHeight(10),
              Review(md),

              // ElevatedButton(
              //     onPressed: () {
              //       Navigator.of(context).push(MaterialPageRoute(
              //           builder: (context) => ReviewScreen(
              //                 id: widget.id,
              //                 md: md,
              //               )));
              //     },
              //     child: Text(
              //       '리뷰',
              //       style: TextStyle(color: Colors.white),
              //     )),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  '추천 영화',
                  style: titleStyle,
                ),
              ),
            ],
          ),
        ),
        eHeight(10),
        RecommendCard(
          title: md.title,
          id: widget.id.toString(),
        ),
        eHeight(75),
      ],
    );
  }

  Widget Review(MovieDetails md) {
    return FutureBuilder<QuerySnapshot>(
      future: ReviewRepository().futureGetReview(movieId: widget.id.toString()),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('에러가 있습니다'),
          );
        }
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        var snap = (snapshot.data! as dynamic);
        reviewList = snap.docs.map((DocumentSnapshot doc) {
          return doc.id;
        }).toList();
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '리뷰 (${snap.docs.length})',
                  style: titleStyle,
                ),
                reviewList.contains(auth.currentUser!.uid)
                    ? Container()
                    : TextButton(
                        onPressed: () {
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) => WriteReviewPopup(
                              movieId: widget.id.toString(),
                              poster_path: md.postUrl,
                              movie_name: md.title,
                            ),
                          );
                        },
                        child: const Text(
                          '리뷰 남기기',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
              ],
            ),
            eHeight(10),
            if (snap.docs.length != 0)
              Column(
                children: [
                  Container(
                    height: snap.docs.length == 1
                        ? 120
                        : snap.docs.length < 2
                            ? 240
                            : 300,
                    child: ListView.builder(
                      physics: snap.docs.length < 2
                          ? const NeverScrollableScrollPhysics()
                          : null,
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: snap.docs.length,
                      itemBuilder: (context, index) => ReviewCard(
                        snap: snap.docs[index].data(),
                        movieId: widget.id.toString(),
                        movieName: md.title,
                        blockList: blockList,
                      ),
                    ),
                  ),
                ],
              ),
            if (snap.docs.length == 0)
              Column(
                children: [
                  Container(
                    height: 75,
                    child: const Center(
                      child: Text('첫 리뷰를 남겨주세요!'),
                    ),
                  ),
                ],
              ),
          ],
        );
      },
    );
  }
}
