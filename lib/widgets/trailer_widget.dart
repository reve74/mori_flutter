import 'package:flutter/material.dart';
import 'package:mori/models/trailer.dart';
import 'package:mori/repository/movie_repository.dart';
import 'package:mori/utils.dart';
import 'package:mori/widgets/video_player.dart';

class TrailerWidget extends StatefulWidget {
  final String movieId;

  TrailerWidget({
    required this.movieId,
    Key? key,
  }) : super(key: key);

  @override
  State<TrailerWidget> createState() => _TrailerWidgetState();
}

class _TrailerWidgetState extends State<TrailerWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Trailer>>(
      future: MovieRepository().getTrailer(widget.movieId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          const Center(child: Text('에러가 있습니다.'));
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        List<Trailer> trailers = snapshot.data!;
        if (trailers.isNotEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  '트레일러',
                  style: titleStyle,
                ),
              ),
              VideoPlayer(keys: trailers[0].key),
            ],
          );
        }
        return Container();
      },
    );
  }
}
