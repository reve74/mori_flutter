import 'package:flutter/material.dart';
import 'package:mori/provider/bottom_navigation_provider.dart';
import 'package:mori/provider/user_provider.dart';
import 'package:mori/repository/auth_repository.dart';
import 'package:mori/screen/tos_screen.dart';
import 'package:mori/screen/update_user_screen.dart';
import 'package:mori/util/const.dart';
import 'package:mori/utils.dart';
import 'package:provider/provider.dart';
import 'package:mori/models/user.dart' as model;
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserProvider? _userProvider;

  BottomNavigationProvider? _bottomNavigationProvider;

  Widget _menuBar({required String title, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 15),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              height: 1,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    _bottomNavigationProvider =
        Provider.of<BottomNavigationProvider>(context, listen: true);
    _userProvider!.initialize();

    Future launchEmail() async {
      final url =
          'mailto:$EmailAdress?subject=${Uri.encodeFull(Inquire)}&body=${Uri.encodeFull(InquireMessage)}';
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        throw 'Could not launch $url';
      }
    }

    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<model.User>(
            stream: _userProvider!.currentUser,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasError) {
                  return const Center(child: Text('에러가 있습니다'));
                }
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      const SizedBox(height: 30),
                      snapshot.data!.profImage != ''
                          ? CircleAvatar(
                              radius: 50,
                              backgroundImage:
                                  NetworkImage(snapshot.data!.profImage!),
                            )
                          : const CircleAvatar(
                              radius: 50,
                              backgroundImage:
                                  ExactAssetImage('assets/img/user.png')),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          snapshot.data!.nickname,
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => UpdateUserScreen(
                                uid: snapshot.data!.uid,
                              ),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/icon/pen.png',
                              width: 15,
                              color: Colors.white,
                            ),
                            const Text(
                              ' 프로필 수정',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 4.0),
                        // color: darkGreyClr,
                        child: Column(
                          children: [
                            // _menuBar(title: 'FAQ'),
                            _menuBar(
                                title: '문의하기',
                                onTap: () async {
                                  launchEmail();
                                }),
                            _menuBar(
                                title: '이용약관 및 개인정보 처리방침',
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => TosScreen()));
                                }),
                            _menuBar(
                              title: '회원 탈퇴',
                              onTap: () {
                                AuthRepository().deleteAccount(context);
                              },
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 20.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  AuthRepository().signOut();
                                  _bottomNavigationProvider!
                                      .updateCurrentPage(0);
                                },
                                child: Text(
                                  '로그아웃',
                                  style: ts,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              return Container();
            }),
      ),
    );
  }
}
