import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:latlng/latlng.dart';
import 'package:location/location.dart';
import 'package:worker_booking/ApplicarionModules/AuthenticationModule/Views/sign_in_view.dart';
import 'package:worker_booking/ApplicarionModules/SearchModule/Views/search_view.dart';
import 'package:worker_booking/ApplicarionModules/WorkerPanel/WorkerHomeModule/VIews/worker_ruote_view.dart';
import 'package:worker_booking/Utils/app_colors.dart';
import 'package:worker_booking/Utils/text_view.dart';

import 'ApplicarionModules/AuthenticationModule/Views/usertype_selection_view.dart';
import 'ApplicarionModules/CustomerPanel/WorkerModule/Views/workers_list_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  String? email;

  Location location = Location();
  bool serviceEnabled = false;
  PermissionStatus? permissionGranted;
  LocationData? locationData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Timer(Duration(seconds: 3), () {
      SplashInitState();
    });
  }

  SplashInitState() async {
    if (FirebaseAuth.instance.currentUser != null) {
      email = await FirebaseAuth.instance.currentUser!.email;
      DocumentSnapshot snapshot =
          await FirebaseFirestore.instance.collection("users").doc(email).get();
      int type = (snapshot.data() as dynamic)["type"] ?? 0;
     await getCurrentLocation().then((value) async {
        if(value!=null){
          await FirebaseFirestore.instance.collection("users").doc(email).update({
            "coordinates": [value.latitude, value.longitude]
          });
          Get.off(
            type == 0 ? SearchView() : WorkerRouteView(),
            //type == 0 ? WorkersListView() : WorkerRouteView(),
            transition: Transition.rightToLeft,
            duration: Duration(milliseconds: 600),
          );
        }else{
          SystemNavigator.pop();

        }

      });
    } else {
      Get.off(
        UsertypeSelectionView(),
        transition: Transition.rightToLeft,
        duration: Duration(milliseconds: 600),
      );
    }
  }

  Future<LatLng?> getCurrentLocation() async {
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        SystemNavigator.pop();
      }
    }
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        SystemNavigator.pop();
      }
    }
    locationData = await location.getLocation();

    if (locationData != null) {
      return LatLng(locationData!.latitude!, locationData!.longitude!);
    } else {
      print("wait");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightmainColor,
      body: Center(
        child: Image.asset("assets/Images/logo.png"),
      ),
    );
  }
}
