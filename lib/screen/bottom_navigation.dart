import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mori/util/colors.dart';
import 'package:mori/util/const.dart';
import 'package:mori/provider/bottom_navigation_provider.dart';
import 'package:mori/repository/auth_repository.dart';
import 'package:mori/screen/home_screen.dart';
import 'package:mori/screen/like_screen.dart';
import 'package:mori/screen/profile_screen.dart';
import 'package:mori/screen/serach_screen.dart';
import 'package:provider/provider.dart';

class BottomNavigation extends StatefulWidget {
  BottomNavigation({Key? key}) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  BottomNavigationProvider? _bottomNavigationProvider;

  // late PageController pageController;
  //
  // @override
  // void initState() {
  //   super.initState();
  //   pageController = PageController();
  // }
  //
  // @override
  // void dispose() {
  //   super.dispose();
  //   pageController.dispose();
  // }


  Widget _navigationBody() {
    switch (_bottomNavigationProvider!.currentPage) {
      case 0:
        return HomeScreen();
      case 1:
        return SearchScreen();
      case 2:
        return LikeScreen();
      case 3:
        return ProfileScreen();
    }
    return Container();
  }

  Widget _bottomNavigationBarWidget() {
    return CupertinoTabBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            color: _bottomNavigationProvider!.currentPage == 0
                ? Colors.white
                : null,
          ),
          // label: "홈",
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.search,
            color: _bottomNavigationProvider!.currentPage == 1
                ? Colors.white
                : null,
          ),
          // label: "검색",
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.favorite_border_outlined,
            color: _bottomNavigationProvider!.currentPage == 2
                ? Colors.white
                : null,
          ),
          // label: "좋아요",
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.account_circle_rounded,
            color: _bottomNavigationProvider!.currentPage == 3
                ? Colors.white
                : null,
          ),
          // label: "프로필",
        ),
      ],
      currentIndex: _bottomNavigationProvider!.currentPage,
      // selectedItemColor: Colors.red,
      onTap: (index) {
        _bottomNavigationProvider!.updateCurrentPage(index);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _bottomNavigationProvider =
        Provider.of<BottomNavigationProvider>(context, listen: true);
    return Scaffold(
      body: _navigationBody(),
      bottomNavigationBar: _bottomNavigationBarWidget(),
    );
  }
}
