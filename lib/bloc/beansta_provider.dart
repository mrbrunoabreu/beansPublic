import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/beansta_photo.dart';
import '../models/profile.dart';

class BeanstaProvider with ChangeNotifier {
  final String baseUrl = 'https://beans-aa4aa.firebaseio.com/';

  Future addPhotoItem(
      {required BeanstaPhoto newphoto, String? photoUrl, required Profile user}) async {
    final CollectionReference timeLineCollection =
        FirebaseFirestore.instance.collection('beansTimeLine');

    final Dio dio = Dio();

    timeLineCollection.add({
      'creationTime': Timestamp.now(),
      'creatorId': user.profileId,
      'creatorName': user.name,
      'creatorPhoto': user.userPhotoUrl,
      'itemPhoto': photoUrl,
      'itemLocation': newphoto.itemLocation,
      'itemDescription': newphoto.itemDescription,
      'likes': [],
      'likesNames': []
    });
  }

  Future deletePhotoItem(
      {required String mealImageUrl, String? itemId, required Profile user}) async {
    final CollectionReference timeLineCollection =
        FirebaseFirestore.instance.collection('beansTimeLine');

    final CollectionReference commentsCollection = FirebaseFirestore.instance
        .collection('beansTimeLine')
        .doc(itemId)
        .collection('comments');

    try {
      commentsCollection.doc().delete();
      timeLineCollection.doc(itemId).delete();
    } catch (e) {
      print(e);
    }

    try {
      final FirebaseStorage storage =
          FirebaseStorage.instanceFor(bucket: 'gs://beans-aa4aa.appspot.com');
      final imagePath = mealImageUrl;
      final pathTrim = imagePath.substring(0, imagePath.indexOf('?'));
      final jpgSection = pathTrim.substring(pathTrim.indexOf('image_picker'));
      final completeUrl = 'images/${user.profileId}/$jpgSection';
      print(pathTrim);
      print(jpgSection);
      final imageRef = storage.ref().child(completeUrl);
      final deleteImage = await imageRef.delete();
    } catch (e) {
      print(e);
    }
  }

  Future addFavorite({String? item, required Profile user}) async {
    var timeLineDoc =
        FirebaseFirestore.instance.collection('beansTimeLine').doc(item);

    return timeLineDoc.update({
      'likes': FieldValue.arrayUnion([user.profileId]),
      'likesNames': FieldValue.arrayUnion([user.name]),
    });
  }

  Future addLikeNotification(
      {String? item, String? itemUid, String? userName}) async {
    var timeLineNotificationDoc = FirebaseFirestore.instance
        .collection('beansTimeLineNotifications')
        .doc(itemUid)
        .collection('notifications')
        .doc();

    return timeLineNotificationDoc.set({
      'likeNotificationMessage': '$userName liked your photo',
      'likedItem': item,
      'timeStamp': Timestamp.now()
    });
  }

  Future removeFavorite({String? item, required Profile user}) async {
    final timeLineDoc =
        FirebaseFirestore.instance.collection('beansTimeLine').doc(item);

    try {
      return await timeLineDoc.update({
        'likes': FieldValue.arrayRemove([user.profileId]),
        'likesNames': FieldValue.arrayRemove([user.name]),
      });
    } catch (e) {
      print(e);
    }
  }

  Future addComment({String? comment, String? item, String? author}) async {
    final timeLineDoc = FirebaseFirestore.instance
        .collection('beansTimeLine')
        .doc(item)
        .collection('comments')
        .doc();

    return timeLineDoc.set({
      'commentAuthor': author,
      'comment': comment,
      'timestamp': Timestamp.now()
    });
  }

  // Future getUserAvatar(item, uid) async {
  //   var timeLineDoc =
  //       FirebaseFirestore.instance.collection('beansTimeLine').doc(item);
  // }

  // Future updateTimeLine() async {
  //   final CollectionReference timeLineCollection =
  //       FirebaseFirestore.instance.collection('beansTimeLine');
  //   FirebaseAuth auth = FirebaseAuth.instance;

  //   var user = auth.currentUser;
  //   final uid = user.uid;

  //   return await timeLineCollection.doc(uid).set({
  //     'creatorId': item.itemId,
  //     'itemPhoto': item.itemPhoto,
  //     'itemLocation': item.itemLocation,
  //     'itemDescription': item.itemDescription,
  //     'likes': item.likes,
  //     'comments': item.comments
  //   });
  // }

  // Profile userProfile;

  // Future<void> createItem(userName, userLastName, userPhotoUrl, userId) async {
  //   final url = 'https://beans-aa4aa.firebaseio.com/beanStagram/$userId.json';
  //   try {
  //     final response = await http.post(url,
  //         body: json.encode({
  //           'userName': userName,
  //           'userLastName': userLastName,
  //           'userPhotoUrl': userPhotoUrl
  //         }));

  //     final newProfile = Profile(
  //         name: userName, lastName: userLastName, userPhotoUrl: userPhotoUrl);

  //     userProfile = newProfile;
  //     print('created a new profile');

  //     notifyListeners();
  //   } catch (error) {
  //     print(error);
  //   }
  // }

  // Future<void> editProfile(userName, userLastName, userPhotoUrl, userId) async {
  //   final url =
  //       'https://beans-aa4aa.firebaseio.com/$userId/userProfile/${userProfile.profileId}.json';
  //   try {
  //     final response = await http.patch(url,
  //         body: json.encode({
  //           'userName': userName,
  //           'userLastName': userLastName,
  //           'userPhotoUrl': userPhotoUrl
  //         }));

  //     final newProfile = Profile(
  //         name: userName, lastName: userLastName, userPhotoUrl: userPhotoUrl);

  //     userProfile = newProfile;
  //     print('edited the profile');

  //     notifyListeners();
  //   } catch (error) {
  //     print(error);
  //   }
  // }

  // Future<void> fetchProfiles(uid) async {
  //   var url = 'https://beans-aa4aa.firebaseio.com/$uid/userProfile.json';
  //   try {
  //     final response = await http.get(url);
  //     final _extractedData = json.decode(response.body) as Map<String, dynamic>;

  //     if (_extractedData == null) {
  //       print('no extracted data');
  //       return;
  //     }
  //     _extractedData.forEach((key, value) {
  //       userProfile = Profile(
  //           profileId: key,
  //           name: value['userName'],
  //           lastName: value['userLastName'],
  //           userPhotoUrl: value['userPhotoUrl']);
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // Future<void> setToken(uid) async {

  //   final userToken = await FirebaseMessaging().getToken();

  //   var timeLineNotificationDoc =
  //       FirebaseFirestore.instance.collection('beansTimeLineNotifications');
  //   try {
  //     return await timeLineNotificationDoc.doc(uid).set({
  //     'userToken': userToken
  //   });
  //   } catch (e) {
  //     print(e);
  //   }
  // }

}
