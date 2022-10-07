import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:mori/screen/bottom_navigation.dart';
import 'package:mori/screen/home_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        children: [
          Image.asset('assets/img/logo.png', fit: BoxFit.cover,),
        ],
      ),
      backgroundColor: Colors.black,
      nextScreen: BottomNavigation(),
    );
  }
}
