import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:worker_booking/ApplicarionModules/ProfileModule/Models/user_model.dart';
import 'package:worker_booking/ApplicarionModules/ProfileModule/ViewModels/profile_view_model.dart';

import '../../../../Utils/text_view.dart';
import '../../CustomerBookingModule/Models/rate_model.dart';

class WorkerViewModel extends GetxController {
  RxList<UserModel> workerList = <UserModel>[].obs;
  RxList<RateModel> rateList = <RateModel>[].obs;



  // RxList<dynamic> coordinate = <dynamic>[].obs;

  RxString searchRes = "".obs;

  ProfileViewModel profileViewModel = Get.put(ProfileViewModel());

  Future<void> getWorkers() async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .snapshots()
          .listen((event) {
        workerList.value = UserModel.jsonToListView(event.docs)
            .where((element) =>
                (latlangfinder(
                      element.coordinates[0],
                      element.coordinates[1],
                      profileViewModel.userList.value[0].coordinates[0],
                      profileViewModel.userList.value[0].coordinates[1],
                    )! <=
                    10.00) &&
                element.type == 1 &&
                element.ocupied == 0 &&
                (element.name.toLowerCase().contains(searchRes.toLowerCase()) ||
                    element.email
                        .toLowerCase()
                        .contains(searchRes.toLowerCase()) ||
                    element.Category
                        .toLowerCase()
                        .contains(searchRes.toLowerCase()) ||
                    element.phoneNumber
                        .toLowerCase()
                        .contains(searchRes.toLowerCase())))
            .toList();
      });
    } catch (e) {
      print(e);
    }
  }



  Future<void> getRatings(String worker) async {
    try {
      await FirebaseFirestore.instance
          .collection("ratings")
          .snapshots()
          .listen((event) {
        rateList.value = RateModel.jsonToListView(event.docs)
            .where((element) =>

            (element.workerEmail.toLowerCase().contains(worker.toLowerCase())
            ))
            .toList();
      });
    } catch (e) {
      print(e);
    }
  }


  double? latlangfinder(firtlat, firstlang, curntulat, curntulang) {
    double calculateDistance(lat1, lon1, lat2, lon2) {
      var p = 0.017453292519943295;
      var c = cos;
      var a = 0.5 -
          c((lat2 - lat1) * p) / 2 +
          c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
      return 12742 * asin(sqrt(a));
    }

    double totalDistance = 0;

    totalDistance += calculateDistance(
      firtlat,
      firstlang,
      curntulat,
      curntulang,
    );
    return totalDistance;
  }
}
