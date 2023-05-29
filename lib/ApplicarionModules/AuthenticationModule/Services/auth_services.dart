import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<int> checkUserType({required String email}) async {
  int type = 3;
  DocumentSnapshot snapshot = await FirebaseFirestore.instance
      .collection("users")
      .doc(email)
      .get();
  if (snapshot.exists) {
    type = (snapshot.data() as dynamic)["type"] ?? 0;
  } else {}
  return type;
}
