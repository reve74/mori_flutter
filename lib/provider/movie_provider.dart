import 'package:flutter/material.dart';
import 'package:mori/models/movie.dart';
import 'package:mori/models/movie_details.dart';
import 'package:mori/models/trailer.dart';
import 'package:mori/repository/movie_repository.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MovieProvider extends ChangeNotifier {
  MovieRepository _movieRepository = MovieRepository();
  List<Movie> _popularMovies = [];
  List<Movie> get popularMV => _popularMovies;

  List<Movie> _nowPlayingMovies = [];
  List<Movie> get nowPlayingMv => _nowPlayingMovies;

  List<MovieDetails> _likesMv = [];
  List<MovieDetails> get likesMv => _likesMv;

  List<Trailer> _trailerKeys = [];
  List<Trailer> get trailerKeys => _trailerKeys;

   YoutubePlayerController? _controller;
   YoutubePlayerController? get controller => _controller;

  popularMovies() async {
    List<Movie> popular = await _movieRepository.popularMovies();
    _popularMovies = popular;
    notifyListeners();
  }

  nowPlayingMovies() async {
    List<Movie> upcoming = await _movieRepository.nowPlayingMovies();
    _nowPlayingMovies = upcoming;
    notifyListeners();
  }

  likesMovies({required String id}) async {
    List<MovieDetails> likes = await _movieRepository.likesMoviesList(id: id);
    _likesMv = likes;
    notifyListeners();
  }


  // // 1. 유튜브 키 얻어오기
  // getTrailerKeys({required String movieId}) async {
  //   List<Trailer> trailers = await _movieRepository.getTrailer(movieId);
  //   print(trailers.length);
  //   print(trailers.map((e) => e.key));
  //   _trailerKeys = [];
  //   _trailerKeys = trailers;
  //   // print(_trailerKeys.map((e) => e.key));
  //   notifyListeners();
  // }
  // // 2. 키 값으로 유튜브 컨트롤러 만들기
  // getYoutubeUrl({required String key}) {
  //   final url = 'https://www.youtube.com/watch?v=$key';
  //   print(url);
  //   _controller = YoutubePlayerController(
  //     initialVideoId: YoutubePlayer.convertUrlToId(url)!,
  //     flags: const YoutubePlayerFlags(
  //       mute: false,
  //       loop: false,
  //       autoPlay: false,
  //     ),
  //   );
  //   _controller = controller;
  //   // notifyListeners;
  // }
}
