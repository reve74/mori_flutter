import 'package:flutter/material.dart';
import 'package:mori/utils.dart';

class GenresCard extends StatelessWidget {
  final String genres;
  const GenresCard({
    required this.genres,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.brown.withOpacity(0.3),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Text(genres, style: ts.copyWith(fontSize: 14)),
      ),
    );
  }
}
