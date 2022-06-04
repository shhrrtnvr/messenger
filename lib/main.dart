//packages
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:provider/provider.dart';

//Services
import './services/navigation_service.dart';

//Providers
import './providers/authentication_provider.dart';

//Pages
import './pages/splash_page.dart';
import './pages/login_page.dart';
import './pages/home_page.dart';
import './pages/register_page.dart';

//Constants
import 'routes.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthenticationProvider>(
          create: (BuildContext context) => AuthenticationProvider(),
        )
      ],
      child: MaterialApp(
        title: 'Messenger',
        theme: ThemeData(
          backgroundColor: const Color.fromARGB(255, 112, 196, 168),
          scaffoldBackgroundColor: const Color.fromARGB(255, 37, 158, 189),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Color.fromARGB(255, 178, 11, 184),
          ),
        ),
        navigatorKey: NavigationService.navigatorKey,
        initialRoute: Routes.loginPage,
        routes: {
          Routes.loginPage: (BuildContext _context) => const LoginPage(),
          Routes.registerPage: (BuildContext _context) => RegisterPage(),
          Routes.homePage: (BuildContext _context) => HomePage(),
        },
      ),
    );
  }
}
