import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mori/provider/user_provider.dart';
import 'package:mori/repository/review_repository.dart';
import 'package:mori/util/const.dart';
import 'package:mori/util/size_helper.dart';
import 'package:mori/utils.dart';
import 'package:mori/widgets/validator.dart';
import 'package:provider/provider.dart';

class ModifyReviewPopup extends StatefulWidget {
  final String movieId;
  final String movie_name;
  final String description;
  ModifyReviewPopup({
    required this.movieId,
    required this.movie_name,
    required this.description,
    Key? key,
  }) : super(key: key);

  @override
  State<ModifyReviewPopup> createState() => _ModifyReviewPopupState();
}

class _ModifyReviewPopupState extends State<ModifyReviewPopup> {
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
                  Text('?????? : ', style: TextStyle(height: 1.8),),
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
                  //TODO: validator ??????
                  validator: (value) {
                    if (value!.isEmpty || value.length < 2) {
                      return '2?????? ?????? ??????????????????';
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
                    '??????',
                    style: ts,
                  ),
                ),
                eWidth(5),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ReviewRepository().modifyReview(
                        movieId: widget.movieId,
                        uid: uid,
                        description: _reviewController.text.trim(),
                        star: star ?? 5.0,
                      );
                      Navigator.of(context).pop();
                      // showSnackBar('????????? ???????????????!', context);
                    }
                  },
                  child: Text(
                    '????????????',
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
