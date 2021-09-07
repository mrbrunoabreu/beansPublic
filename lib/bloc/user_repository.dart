import 'package:blackbeans/models/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserRepository with ChangeNotifier {
  late String uid;
  String baseUrl = 'https://beans-aa4aa.firebaseio.com/';
  final String noProfilePic = 'https://i.ibb.co/vJJ4Qs0/nobeans.png';

  late Profile userProfile;

  Future<void> createProfile(
      {String? userName,
      String? userLastName,
      String? userPhotoUrl,
      String? userId}) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    final _userId = auth.currentUser!.uid;

    var dio = Dio();

    final url = '$baseUrl/$_userId/userProfile.json';
    try {
      final response = await dio.post(url, data: {
        'userName': userName,
        'userLastName': userLastName,
        'userPhotoUrl': userPhotoUrl ?? noProfilePic
      });

      final newProfile = Profile(
          name: userName,
          lastName: userLastName,
          userPhotoUrl: userPhotoUrl ?? noProfilePic);

      userProfile = newProfile;
      print('created a new profile');

      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> editProfile(
      {String? userName,
      String? userLastName,
      String? userPhotoUrl,
      String? userId}) async {
    var dio = Dio();

    final url = '$baseUrl/$uid/userProfile/${userProfile.profileId}.json';
    try {
      final response = await dio.patch(url, data: {
        'userName': userName,
        'userLastName': userLastName,
        'userPhotoUrl': userPhotoUrl
      });

      final newProfile = Profile(
          name: userName, lastName: userLastName, userPhotoUrl: userPhotoUrl);

      userProfile = newProfile;
      print('edited the profile');

      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> fetchProfile() async {
    var dio = Dio();

    FirebaseAuth auth = FirebaseAuth.instance;

    final user = auth.currentUser!;
    final uid = user.uid;
    final userEmail = user.email;

    try {
      final userNotificationDoc = await FirebaseFirestore.instance
          .collection('beansTimeLineNotifications')
          .doc(uid)
          .get();
    } catch (e) {
      print(e);
    }

    var url = '$baseUrl/$uid/userProfile.json';
    try {
      final response = await dio.get(url);
      final _extractedData = response.data as Map<String, dynamic>?;

      if (_extractedData == null) {
        print('no extracted data');
        userProfile = Profile(
            profileId: uid,
            name: 'User',
            lastName: '',
            userPhotoUrl: noProfilePic,
            email: userEmail);
        return;
      }
      _extractedData.forEach((key, value) {
        userProfile = Profile(
            profileId: uid,
            name: value['userName'] as String?,
            lastName: value['userLastName'] as String?,
            userPhotoUrl: value['userPhotoUrl'] as String?,
            email: userEmail);
      });
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> changeEmail(String newEmail) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    var user = auth.currentUser!;
    try {
      user.updateEmail(newEmail);
    } catch (e) {
      print(e);
    }
  }

  Future<void> changePassword(String newPassword) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    var user = auth.currentUser!;
    try {
      user.updatePassword(newPassword);
    } catch (e) {
      print(e);
    }
  }
}
