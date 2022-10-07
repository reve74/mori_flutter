import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mori/provider/bottom_navigation_provider.dart';
import 'package:mori/util/const.dart';
import 'package:mori/models/user.dart' as model;
import 'package:mori/repository/storage_repository.dart';
import 'package:mori/utils.dart';
import 'package:provider/provider.dart';

class AuthRepository {
  BottomNavigationProvider? _bottomNavigationProvider;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Stream<model.User> streamGetUserDetails() {
    User currentUser = _auth.currentUser!;
    return firebaseFirestore
        .collection('users')
        .doc(currentUser.uid)
        .snapshots()
        .map((snapshot) => model.User.fromSnap(snapshot));
  }

  // Stream<model.User> streamReviewUsers({required String uid}) {
  //   return firebaseFirestore
  //       .collection('users')
  //       .doc(uid)
  //       .snapshots()
  //       .map((snapshot) => model.User.fromSnap(snapshot));
  // }

  Future<model.User> futureReviewUsers({required String uid}) async {
    var document = firebaseFirestore.collection('users').doc(uid);
    var data = await document.get();
    return (model.User.fromSnap(data));
  }

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap =
        await _fireStore.collection('users').doc(currentUser.uid).get();
    return model.User.fromSnap(snap);
  }

  // 회원가입
  Future<String> signUpUser({
    required String email,
    required String password,
    required String nickname,
    required BuildContext context,
  }) async {
    String res = 'error';
    try {
      if (email.isNotEmpty || password.isNotEmpty || nickname.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        model.User user = model.User(
          email: email,
          password: password,
          nickname: nickname,
          uid: cred.user!.uid,
          likes: [],
          block: [],
          profImage: '',
        );

        await _fireStore.collection('users').doc(cred.user!.uid).set(
              user.toJson(),
            );
      }
      res = 'success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        showSnackBar('이미 사용중인 이메일 입니다.', context);
      }

      print(e.toString());
    } catch (e) {
      print(e.toString());
    }
    return res;
  }

  // 이메일, 비밀번호 로그인
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = 'error';
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = 'success';
      }
    } on FirebaseAuthException catch (e) {
      print(e);
    } catch (e) {
      print(e);
    }
    return res;
  }

  Future<String> resetPassword({
    required String email,
  }) async {
    String res = 'error';
    try {
      if (email.isNotEmpty) {
        await _auth.sendPasswordResetEmail(
          email: email,
        );
        res = 'success';
      }
    } on FirebaseAuthException catch (e) {
      print(e);
    } catch (e) {
      print(e);
    }
    return res;
  }

  // 로그아웃
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // 유저 업데이트
  Future<void> updateUser(
    String nickname,
    Uint8List? file,
    BuildContext context,
  ) async {
    final loggedUser = auth.currentUser;
    try {
      if (file != null && nickname.isNotEmpty) {
        print('모두 변경!!');
        String profImage = await StorageRepository()
            .uploadImageToStorage("profileImages", file, false);
        await _fireStore.doc('/users/${loggedUser!.uid}').update({
          'nickname': nickname,
          'profImage': profImage,
        });
        showSnackBar('프로필이 업데이트 되었습니다!', context);
      } else if (file != null && nickname.isEmpty) {
        print('프로필만 변경!!');
        String profImage = await StorageRepository()
            .uploadImageToStorage("profileImages", file, false);

        await _fireStore.doc('/users/${loggedUser!.uid}').update({
          'profImage': profImage,
        });
        showSnackBar('프로필이 업데이트 되었습니다!', context);
      } else if (file == null && nickname.isNotEmpty) {
        print('닉네임만 변경!!');
        await _fireStore.doc('/users/${loggedUser!.uid}').update({
          'nickname': nickname,
        });
        showSnackBar('프로필이 업데이트 되었습니다!', context);
      } else if (file == null && nickname.isEmpty) {
        showSnackBar('프로필 사진 또는 닉네임을 변경해 주세요.', context);
      }
    } on FirebaseFirestore catch (e) {
      print(e);
    } catch (e) {
      print(e);
    }
  }

  Future<String> updateUserNickName(
    String nickname,
    // String password,
    Uint8List? file,
  ) async {
    final loggedUser = auth.currentUser;
    String res = 'error';
    try {
      if (file != null) {
        String profImage = await StorageRepository()
            .uploadImageToStorage("profileImages", file, false);

        await _fireStore.doc('/users/${loggedUser!.uid}').update({
          'nickname': nickname,
          // 'password': password,
          'profImage': profImage,
        });
      } else {
        String profImage = '';
        await _fireStore.doc('/users/${loggedUser!.uid}').update({
          'nickname': nickname,
          // 'password': password,
          'profImage': profImage,
        });
      }

      res = 'success';
    } on FirebaseFirestore catch (e) {
      print(e);
    } catch (e) {
      print(e);
    }
    return res;
  }

  // 구글 로그인
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        UserCredential userCredential =
            await auth.signInWithCredential(credential);

        // if you want to do specific task like storing information in firestore
        // only for new users using google sign in (since there are no two options
        // for google sign in and google sign up, only one as of now),
        // do the following:

        if (userCredential.user != null) {
          if (userCredential.additionalUserInfo!.isNewUser) {
            model.User user = model.User(
              email: userCredential.user!.email!,
              password: '',
              nickname: userCredential.user!.displayName!,
              uid: userCredential.user!.uid,
              likes: [],
              block: [],
              profImage: '',
            );
            await _fireStore
                .collection('users')
                .doc(userCredential.user!.uid)
                .set(
                  user.toJson(),
                );
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      showSnackBar(e.message!, context);
    }
  }

  // 페이스북 로그인
  Future<void> signIngWithFacebook(BuildContext context) async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);
      final userCredential =
          await _auth.signInWithCredential(facebookAuthCredential);

      if (userCredential.user != null) {
        if (userCredential.additionalUserInfo!.isNewUser) {
          model.User user = model.User(
            email: userCredential.user!.email!,
            password: '',
            nickname: userCredential.user!.displayName!,
            uid: userCredential.user!.uid,
            likes: [],
            block: [],
            profImage: '',
          );
          await _fireStore
              .collection('users')
              .doc(userCredential.user!.uid)
              .set(
                user.toJson(),
              );
        }
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(e.message!, context);
    }
  }

  // 계정 탈퇴
  Future<void> deleteAccount(BuildContext context) async {
    _bottomNavigationProvider =
        Provider.of<BottomNavigationProvider>(context, listen: false);
    try {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Mori'),
                content: Text('정말 탈퇴하시겠습니까?'),
                actions: [
                  ElevatedButton(
                    onPressed: () async {
                      deleteUser();
                      await auth.currentUser!.delete();
                      Navigator.of(context).pop();
                      _bottomNavigationProvider!.updateCurrentPage(0);
                    },
                    child: Text('확인', style: TextStyle(color: Colors.white)),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('취소', style: TextStyle(color: Colors.white))),
                ],
              ));
    } on FirebaseAuthException catch (e) {
      print(e.toString());
    }
  }

  Future<void> deleteUser() async {
    await firebaseFirestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .delete();
    // await firebaseFirestore.collection('myReview').doc(auth.currentUser!.uid).delete();
    // await firebaseFirestore.collection('review').doc().collection('reviewList').doc(auth.currentUser!.uid).delete();
    // var deleteReview = firebaseFirestore.collection('review').where('uid', isEqualTo: auth.currentUser!.uid);
    // await firebaseFirestore.collection('review').where('uid', isEqualTo: auth.currentUser!.uid);
    // doc().collection('reviewList').doc(auth.currentUser!.uid).delete();
  }

  Future<void> blockUser({
    required String uid,
    required String otherUid,
  }) async {
    try {
      DocumentSnapshot snap =
          await firebaseFirestore.collection('users').doc(uid).get();
      List block = (snap.data() as dynamic)['block'];

      if (block.contains(otherUid)) {
        await firebaseFirestore.collection('users').doc(uid).update({
          'block': FieldValue.arrayRemove([otherUid])
        });
      }else {
        await firebaseFirestore.collection('users').doc(uid).update({
          'block': FieldValue.arrayUnion([otherUid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
