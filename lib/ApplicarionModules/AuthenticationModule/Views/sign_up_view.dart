import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlng/latlng.dart';
import 'package:location/location.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:worker_booking/ApplicarionModules/AuthenticationModule/Views/Components/avater.dart';
import 'package:worker_booking/ApplicarionModules/ProfileModule/Models/user_model.dart';
import 'package:worker_booking/ApplicarionModules/SearchModule/Views/search_view.dart';

import '../../../Utils/app_colors.dart';
import '../../../Utils/btn.dart';
import '../../../Utils/dimensions.dart';
import '../../../Utils/spaces.dart';
import '../../../Utils/text_edit_field.dart';
import '../../../Utils/text_view.dart';
import '../../../Utils/toast.dart';
import '../../CustomerPanel/WorkerModule/Views/WorkerBookingView.dart';
import '../../CustomerPanel/WorkerModule/Views/workers_list_view.dart';
import '../../WorkerPanel/WorkerHomeModule/VIews/worker_ruote_view.dart';

class SignUpView extends StatefulWidget {
  final int type;

  const SignUpView({super.key, required this.type});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  var encodedImage;
  final ImagePicker _picker = ImagePicker();

  bool isChecked = false;
  bool namevalidate = false;
  bool emailvalidate = false;
  bool imgvalidate = false;

  bool expvalidate = false;
  bool phonevalidate = false;
  bool skilllvalidate = false;
  bool passvalidate = false;
  bool passValid = false;
  bool priceValid = false;
  bool emailValid = false;
  bool addresslValid = false;
  final email = TextEditingController();
  final name = TextEditingController();
  final exp = TextEditingController();
  final price = TextEditingController();
  final skills = TextEditingController();
  final password = TextEditingController();
  final phone = TextEditingController();
  final address = TextEditingController();



  bool isLoading = false;
  double lat = 0;
  double long = 0;
  Location location = Location();
  bool serviceEnabled = false;
  // PermissionStatus? permissionGranted;
  LocationData? locationData;
  String imageURL = "";
  bool updateAble = false;
  bool catValid = false;

  String selected = '';
  List catList = [
    "All",
    "Carpenter",
    "Constructor",
    "Electricion",
    "Mechanic",
    "Painter",
    "Plumber",
    "Welder",
  ];

  Future<void> openCamera() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      encodedImage = File(photo!.path);
    });
    if (photo != null) {
      storeUserImage();
    } else {
      print('No Image Path Received');
    }
  }

  Future<void> openGallery() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      encodedImage = File(photo!.path);
    });

    if (photo != null) {
      storeUserImage();
    } else {
      print('No Image Path Received');
    }
  }

  storeUserImage() async {
    imageURL = "";
    final firebaseStorage = FirebaseStorage.instance
        .ref()
        .child('images')
        .child('${DateTime.now().millisecondsSinceEpoch}');
    UploadTask uploadTask = firebaseStorage.putFile(encodedImage);
    TaskSnapshot taskSnapshot = await uploadTask;

    await taskSnapshot.ref.getDownloadURL().then((value) async {
      if (value != null) {
        setState(() {
          imageURL = value;
          updateAble = true;
        });
      }
    });
  }

  Future<LatLng?> getCurrentLocation() async {
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {}
    }
    await location.hasPermission();

    var status = await Permission.location.isDenied;
    var grant = await Permission.location.isGranted;

    if (status) {
      await location.requestPermission();
      if (grant) {}
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
        title: TextView(text: "Sign Up"),
        backgroundColor: AppColors.mainColor,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        height: Dimensions.screenHeight(context),
        width: Dimensions.screenWidth(context),
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: isLoading
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
                    // Container(
                    //   // color: Colors.redAccent,
                    //   child: ClipRRect(
                    //     child: Image.asset("assets/Images/VBA.png"),
                    //   ),
                    // ),
                    // AddVerticalSpace(20),

                    Stack(
                      children: [
                        Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                              color: AppColors.mainColor,
                              shape: BoxShape.circle),
                          padding: EdgeInsets.all(5),
                          child: ClipOval(
                            // borderRadius: BorderRadius.circular(100),
                            child: OptimizedCacheImage(
                              imageUrl: imageURL,
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) => Container(
                                height: 30,
                                width: 30,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    value: downloadProgress.progress,
                                    color: AppColors.white,
                                    strokeWidth: 3,
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) {
                                return Icon(
                                  Icons.error,
                                  color: AppColors.white,
                                );
                              },
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 5,
                          right: 5,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: AppColors.white,
                            ),
                            child: IconButton(
                              onPressed: () {
                                showModalBottomSheet<void>(
                                  context: context,
                                  backgroundColor: AppColors.transparent,
                                  builder: (BuildContext context) {
                                    return Container(
                                      height: 130,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          BTN(
                                            width:
                                                Dimensions.screenWidth(context),
                                            title: "Camera",
                                            color: AppColors.white,
                                            onPressed: () async {
                                              var status = await Permission
                                                  .camera.status;

                                              if (status.isGranted) {
                                                openCamera();
                                                Navigator.pop(context);
                                              } else {
                                                await Permission.camera
                                                    .request();
                                              }
                                            },
                                          ),
                                          BTN(
                                            width:
                                                Dimensions.screenWidth(context),
                                            title: "Gallery",
                                            color: AppColors.white,
                                            onPressed: () async {
                                              var status = await Permission
                                                  .storage.status;

                                              if (status.isGranted) {
                                                openGallery();
                                                Navigator.pop(context);
                                              } else {
                                                await Permission.storage
                                                    .request();
                                              }
                                            },
                                          ),
                                          AddVerticalSpace(5),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              icon: Icon(
                                Icons.camera_alt,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Avatar(avatarUrl: " ", onTap: (){
                    //   showModalBottomSheet<void>(
                    //     context: context,
                    //     backgroundColor: AppColors.transparent,
                    //     builder: (BuildContext context) {
                    //       return Container(
                    //         height: 130,
                    //         child: Column(
                    //           mainAxisAlignment:
                    //           MainAxisAlignment.end,
                    //           children: [
                    //             BTN(
                    //               width:
                    //               Dimensions.screenWidth(context),
                    //               title: "Camera",
                    //               color: AppColors.white,
                    //               onPressed: () async {
                    //                 var status = await Permission
                    //                     .camera.status;
                    //
                    //                 if (status.isGranted) {
                    //                   openCamera();
                    //                   Navigator.pop(context);
                    //                 } else {
                    //                   await Permission.camera
                    //                       .request();
                    //                 }
                    //               },
                    //             ),
                    //             BTN(
                    //               width:
                    //               Dimensions.screenWidth(context),
                    //               title: "Gallery",
                    //               color: AppColors.white,
                    //               onPressed: () async {
                    //                 var status = await Permission
                    //                     .storage.status;
                    //
                    //                 if (status.isGranted) {
                    //                   openGallery();
                    //                   Navigator.pop(context);
                    //                 } else {
                    //                   await Permission.storage
                    //                       .request();
                    //                 }
                    //               },
                    //             ),
                    //             AddVerticalSpace(5),
                    //           ],
                    //         ),
                    //       );
                    //     },
                    //   );
                    //
                    //
                    // }),
                    AddVerticalSpace(20),
                    TextEditField(
                      hintText: "Name",
                      textCapitalization: TextCapitalization.none,
                      preffixIcon: Icon(Icons.person_outline_outlined),
                      textEditingController: name,
                      errorText: namevalidate ? "Name Requried" : null,
                      width: Dimensions.screenWidth(context),
                    ),
                    AddVerticalSpace(20),
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
                      inputType: TextInputType.phone,
                      hintText: "PhoneNo",
                      maxlength: 11,
                      textCapitalization: TextCapitalization.none,
                      preffixIcon: Icon(Icons.phone),
                      textEditingController: phone,
                      errorText: phonevalidate ? "Phone Requried" : null,
                      width: Dimensions.screenWidth(context),
                    ),
                    AddVerticalSpace(20),
                    TextEditField(
                      hintText: "Address",
                      textCapitalization: TextCapitalization.none,
                      preffixIcon: Icon(Icons.map),
                      textEditingController: address,
                      errorText: addresslValid ? "Address Requried" : null,
                      width: Dimensions.screenWidth(context),
                    ),
                    widget.type == 1 ? AddVerticalSpace(20) : SizedBox(),
                    widget.type == 1
                        ? TextEditField(
                            hintText: "Experience",
                            textCapitalization: TextCapitalization.none,
                            preffixIcon: Icon(Icons.history_edu),
                            textEditingController: exp,
                            errorText:
                                expvalidate ? "Experience Requried" : null,
                            width: Dimensions.screenWidth(context),
                          )
                        : SizedBox(),
                    AddVerticalSpace(20),
                    widget.type == 1
                        ? Container(
                            height: 70,
                            child: DropdownButtonFormField2(
                              buttonPadding: EdgeInsets.only(
                                right: 10,
                              ),

                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: AppColors.grey)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: AppColors.mainColor)),
                              ),
                              isExpanded: true,
                              hint: Row(
                                children: [
                                  Icon(
                                    Icons.category_outlined,
                                    color: AppColors.grey,
                                  ),
                                  AddHorizontalSpace(10),
                                  TextView(
                                    text: 'Category',
                                    fontSize: 14,
                                    color: catValid
                                        ? AppColors.red
                                        : AppColors.grey,
                                  ),
                                ],
                              ),
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: AppColors.grey,
                              ),
                              iconSize: 30,
                              buttonHeight: 55,
                              // buttonPadding:
                              // const EdgeInsets.only(left: 20, right: 10),
                              dropdownDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              items: catList
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.category_outlined,
                                              color: AppColors.grey,
                                            ),
                                            AddHorizontalSpace(10),
                                            TextView(
                                              text: item,
                                              fontSize: 14,
                                              color: AppColors.grey,
                                            ),
                                          ],
                                        ),
                                      ))
                                  .toList(),
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select Days.';
                                }
                              },
                              onChanged: (value) {
                                setState(() {
                                  selected = value!;
                                });
                                //Do something when changing the item if you want.
                              },
                            ),
                          )
                        : SizedBox(),
                    widget.type == 1 ? AddVerticalSpace(20) : SizedBox(),
                    widget.type == 1
                        ? TextEditField(
                            hintText: "Skills",
                            textCapitalization: TextCapitalization.none,
                            preffixIcon: Icon(Icons.work_outline),
                            textEditingController: skills,
                            errorText:
                                skilllvalidate ? "Skills Requried" : null,
                            width: Dimensions.screenWidth(context),
                          )
                        : SizedBox(),
                    widget.type == 1 ? AddVerticalSpace(20) : SizedBox(),
                    widget.type == 1
                        ? TextEditField(
                            hintText: "Charges /hours",
                            inputType: TextInputType.number,
                            textCapitalization: TextCapitalization.none,
                            preffixIcon: Icon(Icons.monetization_on_outlined),
                            textEditingController: price,
                            errorText: priceValid ? "Field Requried" : null,
                            width: Dimensions.screenWidth(context),
                          )
                        : SizedBox(),
                     AddVerticalSpace(20),
                    // widget.type == 1 ? AddVerticalSpace(20) : SizedBox(),
                    // widget.type == 1
                    //     ? TextEditField(
                    //         hintText: "Address",
                    //         // textCapitalization: TextCapitalization.none,
                    //         preffixIcon: Icon(Icons.map),
                    //         textEditingController: address,
                    //         errorText: addresslValid ? "Field Requried" : null,
                    //         width: Dimensions.screenWidth(context),
                    //       )
                    //     : SizedBox(),
                    // AddVerticalSpace(20),
                    // widget.type == 1
                    //     ? Container(
                    //         height: 70,
                    //         child: DropdownButtonFormField2(
                    //           buttonPadding: EdgeInsets.only(
                    //             right: 10,
                    //           ),
                    //
                    //           decoration: InputDecoration(
                    //             isDense: true,
                    //             contentPadding: EdgeInsets.zero,
                    //             border: OutlineInputBorder(
                    //                 borderSide:
                    //                     BorderSide(color: AppColors.grey)),
                    //             focusedBorder: OutlineInputBorder(
                    //                 borderSide:
                    //                     BorderSide(color: AppColors.mainColor)),
                    //           ),
                    //           isExpanded: true,
                    //           hint: Row(
                    //             children: [
                    //               Icon(
                    //                 Icons.category_outlined,
                    //                 color: AppColors.grey,
                    //               ),
                    //               AddHorizontalSpace(10),
                    //               TextView(
                    //                 text: 'Category',
                    //                 fontSize: 14,
                    //                 color: catValid
                    //                     ? AppColors.red
                    //                     : AppColors.grey,
                    //               ),
                    //             ],
                    //           ),
                    //           icon: Icon(
                    //             Icons.arrow_drop_down,
                    //             color: AppColors.grey,
                    //           ),
                    //           iconSize: 30,
                    //           buttonHeight: 55,
                    //           // buttonPadding:
                    //           // const EdgeInsets.only(left: 20, right: 10),
                    //           dropdownDecoration: BoxDecoration(
                    //             borderRadius: BorderRadius.circular(15),
                    //           ),
                    //           items: catList
                    //               .map((item) => DropdownMenuItem<String>(
                    //                     value: item,
                    //                     child: Row(
                    //                       children: [
                    //                         Icon(
                    //                           Icons.category_outlined,
                    //                           color: AppColors.grey,
                    //                         ),
                    //                         AddHorizontalSpace(10),
                    //                         TextView(
                    //                           text: item,
                    //                           fontSize: 14,
                    //                           color: AppColors.grey,
                    //                         ),
                    //                       ],
                    //                     ),
                    //                   ))
                    //               .toList(),
                    //           validator: (value) {
                    //             if (value == null) {
                    //               return 'Please select Days.';
                    //             }
                    //           },
                    //           onChanged: (value) {
                    //             setState(() {
                    //               selected = value!;
                    //             });
                    //             //Do something when changing the item if you want.
                    //           },
                    //         ),
                    //       )
                    //     : SizedBox(),

                    TextEditField(
                      hintText: "Password",
                      textCapitalization: TextCapitalization.none,
                      preffixIcon: Icon(Icons.lock_outline),
                      textEditingController: password,
                      errorText: passvalidate ? "Password Requried" : null,
                      width: Dimensions.screenWidth(context),
                      isPassword: true,
                    ),
                    AddVerticalSpace(10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        AddHorizontalSpace(20),
                        Checkbox(
                          activeColor: AppColors.mainColor,
                          value: isChecked,
                          onChanged: (value) {
                            setState(() {
                              isChecked = value!;
                            });
                          },
                        ),
                        TextView(
                          text: "I accept all the Terms & Conditions",
                        ),
                        // AddHorizontalSpace(20)
                      ],
                    ),
                    AddVerticalSpace(10),
                    BTN(
                      width: Dimensions.screenWidth(context) - 100,
                      title: "Sign Up",
                      textColor: AppColors.white,
                      color: AppColors.mainColor,
                      fontSize: 15,
                      onPressed: () async {
                        if (name.text.isEmpty) {
                          setState(() {
                            namevalidate = true;
                          });
                        } else if (email.text.isEmpty) {
                          setState(() {
                            emailvalidate = true;
                          });
                        } else if (password.text.isEmpty) {
                          setState(() {
                            passvalidate = true;
                          });
                        } else if (imageURL.isEmpty) {
                          setState(() {
                            imgvalidate = true;
                          });
                        } else if (isChecked == false) {
                          FlutterSimpleToast(
                              msg: "Agree to Terms & Conditions");
                        } else {
                          try {
                            setState(() {
                              isLoading = true;
                            });
                            await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                              email: email.text,
                              password: password.text,
                            )
                                .then((value) async {
                              await getCurrentLocation().then((value) async {
                                await FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(email.text)
                                    .set(
                                  {
                                    "name": name.text,
                                    "email": email.text,
                                    "phoneNumber": phone.text,
                                    "address": address.text,
                                    "type": widget.type,
                                    "ocupied": 0,
                                    "Category":
                                        widget.type == 1 ? selected : "",
                                    "experience":
                                        widget.type == 1 ? exp.text : "",
                                    "skills":
                                        widget.type == 1 ? skills.text : "",
                                    "price": widget.type == 1
                                        ? int.parse(price.text)
                                        : 0,
                                    "coordinates": [
                                      value!.latitude,
                                      value.longitude
                                    ],
                                    "FCMToken": await FirebaseMessaging.instance
                                        .getToken(),
                                    "userImage": imageURL
                                  },
                                ).then((value) {
                                  Get.off(
                                    widget.type == 0
                                        // ? WorkersListView()
                                        ? SearchView()
                                        : WorkerRouteView(),
                                    transition: Transition.rightToLeft,
                                    duration: Duration(milliseconds: 600),
                                  );
                                  setState(() {
                                    isLoading = false;
                                  });
                                });
                              });
                            });
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'weak-password') {
                              FlutterErrorToast(
                                error: 'The password provided is too weak.',
                              );
                            } else if (e.code == 'email-already-in-use') {
                              FlutterErrorToast(
                                  error:
                                      "The account already exists for this email.");
                            }
                            setState(() {
                              isLoading = false;
                            });
                          }
                        }
                      },
                    ),
                    AddVerticalSpace(20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextView(text: "Already have an account?"),
                        AddHorizontalSpace(5),
                        InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: TextView(
                            text: "Sign In",
                            color: AppColors.mainColor,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    AddVerticalSpace(20),
                  ],
                ),
              ),
      ),
    );
  }
}
