import 'package:flutter/material.dart';
import 'package:mori/repository/movie_repository.dart';
import 'package:mori/screen/movie_details_screen.dart';
import 'package:mori/util/const.dart';
import 'package:mori/util/size_helper.dart';

class LikeMessagePopup extends StatelessWidget {
  final String title;
  final int id;
  // final String message;

  const LikeMessagePopup({
    required this.title,
    required this.id,
    // required this.message,
    Key? key,
  }) : super(key: key);

  void goToDetail(BuildContext context, int id) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => MovieDetailsScreen(id: id),
      ),
    );
  }

  void delete({required int id, required BuildContext context}) {
    MovieRepository().likeMovies(
      movieId: id.toString(),
      uid: auth.currentUser!.uid,
    );
    Navigator.of(context).pop();
  }

  Widget selectCard({
    required String name,
    required IconData icon,
    required Function() onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          Container(
            height: 2,
            color: Colors.white30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Icon(icon),
               eWidth(10),
                Text(name),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.start,
      titlePadding: EdgeInsets.symmetric(horizontal: 10.0),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Spacer(),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.clear),
              ),
            ],
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: [
        Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            selectCard(
              name: '상세보기',
              icon: Icons.movie,
              onPressed: () {
                goToDetail(context, id);
              },
            ),
            selectCard(
              name: '삭제',
              icon: Icons.delete,
              onPressed: () {
                delete(id: id, context: context);
              },
            ),
          ],
        ),
      ],
    );
  }
}
