import 'package:flutter/material.dart';
import 'package:mori/provider/movie_provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayer extends StatefulWidget {
  final String keys;
  const VideoPlayer({
    required this.keys,
    Key? key,
  }) : super(key: key);

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  YoutubePlayerController? _controller;

  @override
  void initState() {
    super.initState();
    final url = 'https://www.youtube.com/watch?v=${widget.keys}';
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(url)!,
      flags: const YoutubePlayerFlags(
        mute: false,
        loop: false,
        autoPlay: false,
        forceHD: true,
      ),
    );
  }
  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: _controller!,
        ),
        builder: (context, player) {
          return player;
        },
      );
  }
}