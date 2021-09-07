import 'package:blackbeans/auth/loginPage.dart';
import 'package:blackbeans/bloc/recipes_provider.dart';
import 'package:blackbeans/screens/recipes_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    if (firebaseUser != null) {
      Provider.of<RecipesProvider>(context, listen: false).staffSuggestions();
      return RecipesHome();
      // return homepage();
    } else {
      return LoginPage();
      // return signInPage()
    }
  }
}
