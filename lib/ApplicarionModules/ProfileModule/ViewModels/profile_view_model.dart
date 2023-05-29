import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../Models/user_model.dart';

class ProfileViewModel extends GetxController {
  RxList<UserModel> userList = <UserModel>[].obs;
  RxList<UserModel> allUserList = <UserModel>[].obs;
  // RxList<UserModel> hostList = <UserModel>[].obs;

  // Future<void> getUser({required String email}) async {
  //   await FirebaseFirestore.instance
  //       .collection("users")
  //       .snapshots()
  //       .listen((event) {
  //     hostList.value = UserModel.jsonToListView(event.docs)
  //         .where((element) =>
  //     element.email ==email)
  //         .toList();
  //   });
  // }


  getCurrentUser() async {
    print(FirebaseAuth.instance.currentUser!.email);
    await FirebaseFirestore.instance
        .collection("users")
        .snapshots()
        .listen((event) {
      allUserList.value = UserModel.jsonToListView(event.docs);
      userList.value = UserModel.jsonToListView(event.docs)
          .where((element) =>
      element.email ==FirebaseAuth.instance.currentUser!.email)
          .toList();
    });
  }



}