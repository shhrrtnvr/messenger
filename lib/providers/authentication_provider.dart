//Packages
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:messenger/models/chat_user.dart';

//Services
import '../services/database_service.dart';
import '../services/navigation_service.dart';
import '../models/chat_user.dart';

//Constants
import '../routes.dart';

class AuthenticationProvider extends ChangeNotifier {
  late final FirebaseAuth _auth;
  late final NavigationService _navigationService;
  late final DatabaseService _databaseService;

  late ChatUser user;

  AuthenticationProvider() {
    _auth = FirebaseAuth.instance;
    _navigationService = GetIt.instance.get<NavigationService>();
    _databaseService = GetIt.instance.get<DatabaseService>();

    _auth.authStateChanges().listen((_user) {
      if (_user != null) {
        _databaseService.updateUserLastSeenTime(_user.uid);
        _databaseService.getUser(_user.uid).then((snapshot) {
          Map<String, dynamic> _userData =
              snapshot.data()! as Map<String, dynamic>;
          user = ChatUser.fromJSON({
            "uid": _user.uid,
            "name": _userData["name"],
            "email": _userData["email"],
            "last_active": _userData["last_active"],
            "image": _userData["image"],
          });
          _navigationService.removeAndNavigateToRoute(Routes.homePage);
        });
      } else {
        _navigationService.removeAndNavigateToRoute(Routes.loginPage);
      }
    });
  }

  Future<void> loginUsingEmailAndPassword(
      String _email, String _password) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: _email, password: _password);
      print('login successful');
    } on FirebaseAuthException {
      print('Error login user into Firebase');
    } catch (e) {
      print(e);
    }
  }

  Future<String?> registerUserUsingEmailAndPassword(
      String _email, String _password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: _email, password: _password);
      return credential.user!.uid;
    } on FirebaseAuthException {
      print("Error registering user");
    } catch (e) {
      print(e);
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print(e);
    }
  }
}
