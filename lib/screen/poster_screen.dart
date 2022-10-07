import 'package:flutter/material.dart';
import 'package:mori/util/const.dart';

class PosterScreen extends StatelessWidget {
  final String title;
  final String poster_Path;
  const PosterScreen({
    required this.title,
    required this.poster_Path,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Container(
          child: Image.network(poster_Path),
        ),
      ),
    );
  }
}
