import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'package:mori/repository/auth_repository.dart';
import 'package:mori/models/user.dart' as model;
import 'package:mori/util/const.dart';

class UserProvider extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();
  // User? _user;
  // User? get user => _user!;
  // Stream<User?> get authState => FirebaseAuth.instance.authStateChanges();

  Stream<model.User>? _currentUser;
  Stream<model.User>? get currentUser => _currentUser;

  initialize() async {
    _currentUser = firebaseFirestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .snapshots()
        .map((user) => model.User.fromSnap(user));
  }

  Stream<model.User> get streamGetUserDetails {
    User? currentUser = auth.currentUser;
    return firebaseFirestore
        .collection('users')
        .doc(currentUser!.uid)
        .snapshots()
        .map(
          (snapshot) => model.User.fromSnap(snapshot),
        );
  }

}
