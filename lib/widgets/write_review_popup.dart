import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mori/provider/user_provider.dart';
import 'package:mori/repository/review_repository.dart';
import 'package:mori/util/const.dart';
import 'package:mori/util/size_helper.dart';
import 'package:mori/utils.dart';
import 'package:mori/widgets/validator.dart';
import 'package:provider/provider.dart';

class WriteReviewPopup extends StatefulWidget {
  final String movieId;
  final String poster_path;
  final String movie_name;
  WriteReviewPopup({
    required this.movieId,
    Key? key,
    required this.poster_path,
    required this.movie_name,
  }) : super(key: key);

  @override
  State<WriteReviewPopup> createState() => _WriteReviewPopupState();
}

class _WriteReviewPopupState extends State<WriteReviewPopup> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _reviewController = TextEditingController();
  bool _isLoading = false;
  bool likes = false;
  bool isExpanded = true;
  ScrollController scrollController = ScrollController();
  String nickName = '';
  String profImage = '';
  String uid = '';
  double? star;

  @override
  initState() {
    super.initState();
    getData();
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
      nickName = userSnap.data()!['nickname'];
      profImage = userSnap.data()!['profImage'];
      uid = userSnap.data()!['uid'];

      setState(() {});
    } catch (e) {
      print(e.toString());
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ts = TextStyle(
      color: Colors.white,
    );
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: Colors.black45,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.movie_name,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '평점 : ',
                    style: TextStyle(height: 1.8),
                  ),
                  RatingBar.builder(
                    itemSize: 30.0,
                    initialRating: 5,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.only(right: 4.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      print(rating);
                      setState(() {
                        star = rating;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      actions: [
        Column(
          children: [
            Container(
              height: 120,
              width: double.infinity,
              child: Form(
                key: _formKey,
                child: TextFormField(
                  //TODO: validator 필요
                  validator: (value) {
                    if (value!.isEmpty || value.length < 2) {
                      return '2글자 이상 입력해주세요';
                    }
                    return null;
                  },
                  controller: _reviewController,
                  autofocus: true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Colors.grey.shade700,
                  ),
                  cursorColor: Colors.white,
                  maxLength: 50,
                  expands: true,
                  maxLines: null,
                ),
              ),
            ),
            eHeight(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: Navigator.of(context).pop,
                  child: Text(
                    '취소',
                    style: ts,
                  ),
                ),
                eWidth(5),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ReviewRepository().uploadReview(
                        movieId: widget.movieId,
                        uid: uid,
                        description: _reviewController.text.trim(),
                        nickName: nickName,
                        star: star ?? 5.0,
                        poster_path: widget.poster_path,
                        movie_name: widget.movie_name,
                      );
                      Navigator.of(context).pop();
                      // showSnackBar('리뷰를 남겼습니다!', context);
                    }
                  },
                  child: Text(
                    '작성하기',
                    style: ts,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
