class Review {
  final String description;
  final String uid;
  final datePublished;
  final double star;
  final int id;
  final String poster_path;
  final String movie_name;
  final String nickName;

  Review({
    required this.description,
    required this.uid,
    required this.datePublished,
    required this.star,
    required this.id,
    required this.poster_path,
    required this.movie_name,
    required this.nickName,
  });

  Map<String, dynamic> toJson() => {
        'description': description,
        'uid': uid,
        'datePublished': datePublished,
        'star': star,
        'id': id,
        'poster_path': poster_path,
        'movie_name': movie_name,
    'nickName': nickName,
      };

  factory Review.fromJson({required Map<String, dynamic> json}) {
    return Review(
      description: json['description'] as String,
      uid: json['uid'] as String,
      datePublished: json['datePublished'] as String,
      star: json['star'] as double,
      id: json['id'] as int,
      poster_path: json['poster_path'] as String,
      movie_name: json['movie_name'] as String,
      nickName: json['nickName'] as String,
    );
  }
}
