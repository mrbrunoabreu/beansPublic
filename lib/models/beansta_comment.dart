import 'package:cloud_firestore/cloud_firestore.dart';

class BeanstaComment { 
  String? itemId;
  String? comment;
  String? commentAuthor;
  Timestamp? timestamp;

  BeanstaComment({this.itemId, this.comment, this.commentAuthor, this.timestamp});
}