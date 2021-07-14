import 'package:firebase_auth/firebase_auth.dart';

class GetUserId {
  String uid() {
    FirebaseAuth auth = FirebaseAuth.instance;
    return auth.currentUser.uid;
  }
}
