import 'package:blackbeans/auth/authService.dart';
import 'package:blackbeans/auth/loginPage.dart';
import 'package:blackbeans/screens/recipes_home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();

    if (firebaseUser != null) {
      return RecipesHome();
      // return homepage();
    } else {
      return LoginPage();
      // return signInPage()
    }
  }
}
