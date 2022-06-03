import 'package:flutter/material.dart';

//Packages
import 'package:firebase_analytics/firebase_analytics.dart';

//Services
import './services/navigation_service.dart';

//Pages
import './pages/splash_page.dart';

void main() {
  runApp(
    SplashPage(
      key: UniqueKey(),
      onInitializationComplete: () {
        runApp(
          const MainApp(),
        );
      },
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Messenger',
      theme: ThemeData(
        backgroundColor: const Color.fromARGB(255, 112, 196, 168),
        scaffoldBackgroundColor: const Color.fromARGB(255, 37, 158, 189),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color.fromARGB(255, 178, 11, 184),
        ),
      ),
      // navigatorKey: NavigationService.navigatorKey,
    );
  }
}
