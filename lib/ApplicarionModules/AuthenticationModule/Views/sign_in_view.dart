import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:latlng/latlng.dart';
import 'package:location/location.dart';
import 'package:worker_booking/ApplicarionModules/AuthenticationModule/Services/auth_services.dart';
import 'package:worker_booking/ApplicarionModules/AuthenticationModule/Views/sign_up_view.dart';
import 'package:worker_booking/ApplicarionModules/WorkerPanel/WorkerHomeModule/VIews/worker_ruote_view.dart';

import '../../../Utils/app_colors.dart';
import '../../../Utils/btn.dart';
import '../../../Utils/dimensions.dart';
import '../../../Utils/spaces.dart';
import '../../../Utils/text_edit_field.dart';
import '../../../Utils/text_view.dart';
import '../../../Utils/toast.dart';
import '../../CustomerPanel/WorkerModule/Views/workers_list_view.dart';
import '../../SearchModule/Views/search_view.dart';

class SignInView extends StatefulWidget {
  final int type;

  const SignInView({super.key, required this.type});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  bool loading = false;
  final email = TextEditingController();
  final password = TextEditingController();

  bool emailvalidate = false;
  bool passvalidate = false;

  Location location = Location();
  bool serviceEnabled = false;
  PermissionStatus? permissionGranted;
  LocationData? locationData;

  Future<LatLng?> getCurrentLocation() async {
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {}
    }
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {}
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
      appBar: AppBar(
        title: TextView(text: "Sign In"),
        backgroundColor: AppColors.mainColor,
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: Container(
        height: Dimensions.screenHeight(context),
        width: Dimensions.screenWidth(context),
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: loading
            ? Center(
                child: SpinKitThreeBounce(
                  color: AppColors.mainColor,
                  size: MediaQuery.of(context).size.width / 8,
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AddVerticalSpace(50),
                    Container(
                       // color: Colors.redAccent,
                      child: ClipRRect(
                        child: Image.asset("assets/Images/VBA.png",height:300,width:300),
                      ),
                    ),
                    TextEditField(
                      hintText: "Email",
                      textCapitalization: TextCapitalization.none,
                      preffixIcon: Icon(Icons.email_outlined),
                      textEditingController: email,
                      errorText: emailvalidate ? "Email Requried" : null,
                      width: Dimensions.screenWidth(context),
                    ),
                    AddVerticalSpace(20),
                    TextEditField(
                      hintText: "Password",
                      textCapitalization: TextCapitalization.none,
                      preffixIcon: Icon(Icons.lock_outline),
                      textEditingController: password,
                      width: Dimensions.screenWidth(context),
                      errorText: passvalidate ? "Password Requried" : null,
                      isPassword: true,
                    ),
                    AddVerticalSpace(10),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: [
                    //     InkWell(
                    //       onTap: () {},
                    //       child: TextView(
                    //         text: "Forget Password?",
                    //         color: AppColors.mainColor,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    AddHorizontalSpace(20),
                    AddVerticalSpace(20),
                    BTN(
                      width: Dimensions.screenWidth(context) - 100,
                      title: "Sign In",
                      textColor: AppColors.white,
                      color: AppColors.mainColor,
                      fontSize: 15,
                      onPressed: () async {
                        setState(() {
                          if (email.text.isEmpty) {
                            emailvalidate = true;
                          } else if (password.text.isEmpty) {
                            passvalidate = true;
                          } else {
                            emailvalidate = false;
                            passvalidate = false;
                          }
                        });
                        if (email.text.isNotEmpty && password.text.isNotEmpty) {
                          setState(() {
                            loading = true;
                          });
                          try {
                            await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                              email: email.text,
                              password: password.text,
                            )
                                .then((v) {
                              checkUserType(email: email.text)
                                  .then((type) async {
                                getCurrentLocation().then((value) async {
                                  await FirebaseFirestore.instance
                                      .collection("users")
                                      .doc(email.text)
                                      .update({
                                    "coordinates": [
                                      value!.latitude,
                                      value.longitude
                                    ],
                                    "FCMToken": await FirebaseMessaging.instance
                                        .getToken()
                                  });
                                  Get.offAll(
                                    type == 0
                                        //? WorkersListView()
                                        ? SearchView()
                                        : WorkerRouteView(),
                                    transition: Transition.rightToLeft,
                                    duration: Duration(milliseconds: 600),
                                  );
                                });
                              });
                            });
                          } on FirebaseAuthException catch (e) {
                            print(e.code);
                            if (e.code == 'user-not-found') {
                              FlutterErrorToast(error: "Invalid Email");
                            } else if (e.code == 'wrong-password') {
                              FlutterErrorToast(error: "Invalid Password");
                            }

                            setState(() {
                              loading = false;
                              emailvalidate = false;
                              passvalidate = false;
                              // email.text = "";
                              // password.text = "";
                            });
                          }
                        }
                      },
                    ),
                    AddVerticalSpace(20),
                  ],
                ),
              ),
      ),
      bottomNavigationBar: loading
          ? SizedBox()
          : Container(
              width: Dimensions.screenWidth(context),
              padding: EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextView(text: "Don't have an account?"),
                  AddHorizontalSpace(5),
                  InkWell(
                    onTap: () {
                      Get.to(
                        SignUpView(type: widget.type),
                        transition: Transition.rightToLeft,
                        duration: Duration(milliseconds: 600),
                      );
                    },
                    child: TextView(
                      text: "Sign Up",
                      color: AppColors.mainColor,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
