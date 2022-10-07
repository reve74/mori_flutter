import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String nickname;
  final String uid;
  final String email;
  final String password;
  final String? profImage;
  final List? likes;
  final List? block;

  User({
    required this.nickname,
    required this.uid,
    required this.email,
    required this.password,
    required this.profImage,
    required this.likes,
    required this.block,
  });


  Map<String, dynamic> toJson() => {
    "uid": uid,
    "email": email,
    "password": password,
    "profImage": profImage,
    "nickname": nickname,
    "likes": likes,
    "block" : block,
  };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return User(
      nickname: snapshot['nickname'],
      uid: snapshot['uid'],
      email: snapshot['email'],
      profImage: snapshot['profImage'],
      password: snapshot['password'],
      likes: snapshot['likes'],
      block: snapshot['block'],
    );
  }
}
