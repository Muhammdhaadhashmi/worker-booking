import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../ProfileModule/Models/user_model.dart';
import '../Models/chat_model.dart';

class ChatViewModel extends GetxController {
  RxList<ChatModel> chatList = <ChatModel>[].obs;
  RxList<UserModel> inboxList = <UserModel>[].obs;
  RxString searchRes = "".obs;

  getChat({required String email}) async {

    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection("inbox")
        .doc("${email}")
        .collection("messages")
        .orderBy("time", descending: true)
        .snapshots()
        .listen((event) {
          chatList.value = ChatModel.JsonToListView(event.docs);
    });
  }

  getInbox() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection("inbox")
        .snapshots()
        .listen((event) {
      inboxList.value = UserModel.jsonToListView(event.docs).where((element) => element.name
          .toLowerCase()
          .contains(searchRes.value.toLowerCase()) ||
          element.email
              .toLowerCase()
              .contains(searchRes.value.toLowerCase()) ||
          element.phoneNumber.toString()
              .toLowerCase()
              .contains(searchRes.value.toLowerCase())).toList();
    });

  }






}
