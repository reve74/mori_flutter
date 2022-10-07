import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mori/firebase_options.dart';
import 'package:mori/provider/bottom_navigation_provider.dart';
import 'package:mori/provider/movie_provider.dart';
import 'package:mori/provider/user_provider.dart';
import 'package:mori/repository/auth_repository.dart';
import 'package:mori/screen/bottom_navigation.dart';
import 'package:mori/screen/signin_screen.dart';
import 'package:mori/utils.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) => BottomNavigationProvider(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => MovieProvider(),
        ),
        Provider<AuthRepository>(
          create: (BuildContext context) => AuthRepository(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: Themes.dark,
        home: App(),
      ),
    );
  }
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              return BottomNavigation();
            } else if (snapshot.hasError) {
              return Text('${snapshot.hasError}');
            }
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return SignInScreen();
        },
      ),
    );
  }
}
