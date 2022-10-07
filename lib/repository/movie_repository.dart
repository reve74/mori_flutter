import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:mori/models/movie.dart';
import 'package:mori/models/movie_details.dart';
import 'package:mori/models/trailer.dart';
import 'package:mori/util/const.dart';

class MovieRepository {
  // 인기 영화 목록
  Future<List<Movie>> popularMovies() async {
    final response = await Dio().get(
      'https://api.themoviedb.org/3/movie/popular',
      queryParameters: {
        'api_key': API_KEY,
        'language': LANGUAGE,
      },
    );

    return response.data['results']
        .map<Movie>((e) => Movie.fromJson(json: e))
        .toList();
  }

  // 상영중인 영화 리스트
  Future<List<Movie>> nowPlayingMovies() async {
    final response = await Dio().get(
      'https://api.themoviedb.org/3/movie/now_playing', // 상영중
      queryParameters: {
        'api_key': API_KEY,
        'language': LANGUAGE,
        'region': 'KR',
      },
    );
    return response.data['results']
        .map<Movie>((e) => Movie.fromJson(json: e))
        .toList();
  }

  // 영화 상세정보
  Future<MovieDetails> getMovieDetails({required int id}) async {
    final response = await Dio().get(
      'https://api.themoviedb.org/3/movie/$id',
      queryParameters: {
        'api_key': API_KEY,
        'language': LANGUAGE,
      },
    );

    return MovieDetails.fromJson(json: response.data);
  }

  // 찜한 콘텐츠 로딩한번에 리스트
  Future<List<MovieDetails>> getMovieList({required List movieIdList}) async {
    // print(movieIdList.asMap().values);
    // print(movieIdList.map((e) => e));
    var res;
    // print(movieIdList);

    for(String id in movieIdList) {
      final response = await Dio().get(
        'https://api.themoviedb.org/3/movie/${id}',
        queryParameters: {
          'api_key': API_KEY,
          'language': LANGUAGE,
        },
      );
      // print(response.data);

      res = response;
      // print(res.data);
    }
    return res.data.map<MovieDetails>((e) => MovieDetails.fromJson(json: e)).toList();
  }

  List getLikesList({required List likes}) {
    final response =
        likes.map((like) => getMovieDetails(id: int.parse(like))).toList();

    print(response);
    return response;
  }

  // 영화 좋아요 리스트 추가
  Future<void> likeMovies(
      {required String uid, required String movieId}) async {
    try {
      DocumentSnapshot snap =
          await firebaseFirestore.collection('users').doc(uid).get();
      List likes = (snap.data() as dynamic)['likes'];

      // 삭제
      if (likes.contains(movieId)) {
        await firebaseFirestore.collection('users').doc(uid).update({
          'likes': FieldValue.arrayRemove([movieId])
        });
      } else {
        // 추가
        await firebaseFirestore.collection('users').doc(uid).update({
          'likes': FieldValue.arrayUnion([movieId])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // 찜하기 리스트
  Future<List<MovieDetails>> likesMoviesList({required String id}) async {
    final response = await Dio().get(
      'https://api.themoviedb.org/3/movie/$id',
      queryParameters: {
        'api_key': API_KEY,
        'language': LANGUAGE,
      },
    );
    return response.data
        .map<MovieDetails>((e) => MovieDetails.fromJson(json: e))
        .toList();
  }

  // 추천 영화 리스트
  Future<List<Movie>> recommendMovies(String id) async {
    final response = await Dio().get(
      'https://api.themoviedb.org/3/movie/$id/recommendations',
      queryParameters: {
        'api_key': API_KEY,
        'language': LANGUAGE,
      },
    );

    return response.data['results']
        .map<Movie>((e) => Movie.fromJson(json: e))
        .toList();
  }

  // 영화 검색
  Future<List<Movie>> searchMovies(String query) async {
    final response = await Dio().get(
      'https://api.themoviedb.org/3/search/movie',
      queryParameters: {
        'api_key': API_KEY,
        'language': LANGUAGE,
        'query': query,
      },
    );

    return response.data['results']
        .map<Movie>((e) => Movie.fromJson(json: e))
        .toList();
  }

  Future<List<Trailer>> getTrailer(String movieId) async {
    final response = await Dio().get(
      'https://api.themoviedb.org/3/movie/$movieId/videos',
      queryParameters: {
        'api_key': API_KEY,
        'language': LANGUAGE,
      },
    );
    // print(response.data);
    return response.data['results']
        .map<Trailer>((e) => Trailer.fromJson(json: e))
        .toList();
  }

}
