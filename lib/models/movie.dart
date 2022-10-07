class Movie {
  final String title;
  final String poster_path;
  // final String backdrop_path;
  final int id;
  final List genre_ids;
  final String release_date;
  final String overview;

  Movie({
    required this.title,
    required this.poster_path,
    // required this.backdrop_path,
    required this.id,
    required this.genre_ids,
    required this.release_date,
    required this.overview,
  });

  factory Movie.fromJson({required Map<String, dynamic> json}) {
    return Movie(
      title: json['title'] as String,
      poster_path: json['poster_path'] == null ? '' : json['poster_path'] as String,
      // backdrop_path: json['backdrop_path'] as String,
      id: json['id'] as int,
      genre_ids: json['genre_ids'] as List,
      release_date: json['release_date'] == null ? '' : json['release_date'] as String,
      overview: json['overview'] as String,
    );
  }
  String get postUrl => 'https://image.tmdb.org/t/p/w500/${this.poster_path}';
  // String get backDropUrl => 'https://image.tmdb.org/t/p/w500/${this.backdrop_path}';
}
