class MovieDetails {
  final String title;     // 제목
  final String poster_path; // 포스터
  final String tagline;   // 한줄 요약
  final String overview;  //
  final List genres;      // 장르
  // final Map belongs_to_collection;
  final int id;           // 영화 id
  final String release_date;
  final int runtime;
  final String backdrop_path;

  MovieDetails({
    required this.title,
    required this.poster_path,
    required this.tagline,
    required this.overview,
    required this.genres,
    // required this.belongs_to_collection,
    required this.id,
    required this.release_date,
    required this.runtime,
    required this.backdrop_path,
  });

  factory MovieDetails.fromJson({required Map<String, dynamic> json}) {
    return MovieDetails(
      title: json['title'] as String,
      poster_path: json['poster_path'] == null ? '' : json['poster_path'] as String,
      tagline: json['tagline'] as String,
      overview: json['overview'] as String,
      genres: json['genres'] == null ? '' as List : json['genres'] as List,
      id: json['id'] as int,
      release_date: json['release_date'] == null ? '' : json['release_date'] as String,
      runtime: json['runtime'] as int,
      backdrop_path: json['backdrop_path'] == null ? '' : json['backdrop_path'] as String,
    );
  }

  String get postUrl => 'https://image.tmdb.org/t/p/w500/${this.poster_path}';
  String get backDropUrl => 'https://image.tmdb.org/t/p/w500/${this.backdrop_path}';
}
