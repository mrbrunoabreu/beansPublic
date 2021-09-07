import 'package:cloud_firestore/cloud_firestore.dart';

class BeanstaPhoto {
  Timestamp? creationTime;
  String? creatorId;
  String? creatorName;
  String? creatorPhoto;
  String? itemDescription;
  String? itemLocation;
  String? itemPhoto;
  String? itemTitle;
  List<String>? likes;
  List<String>? likesNames;
}
