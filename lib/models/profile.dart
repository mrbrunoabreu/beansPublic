import 'package:flutter/material.dart';

class Profile with ChangeNotifier {

  String? profileId;
  String? name;
  String? lastName;
  String? userPhotoUrl;
  String? email;
  String? password;
  bool isDarkMode;

  Profile({this.profileId, this.name, this.lastName, this.userPhotoUrl, this.email, this.password, this.isDarkMode = false});
}