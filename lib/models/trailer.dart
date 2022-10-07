class Trailer {
  final String name;
  final String type;
  final String key;

  Trailer({
    required this.name,
    required this.type,
    required this.key,
  });

  factory Trailer.fromJson({required Map<String, dynamic> json}) {
    return Trailer(
      name: json['name'] as String,
      type: json['type'] as String,
      key: json['key'] as String,
    );
  }
}
