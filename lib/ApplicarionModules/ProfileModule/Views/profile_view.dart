import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:worker_booking/Utils/spaces.dart';
import 'package:worker_booking/Utils/text_edit_field.dart';

import '../../../Utils/app_colors.dart';
import '../../../Utils/btn.dart';
import '../../../Utils/dimensions.dart';
import '../../../Utils/text_view.dart';
import '../ViewModels/profile_view_model.dart';

class ProfileView extends StatefulWidget {
  final showAppBar;

  const ProfileView({
    Key? key,
    required this.showAppBar,
  }) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  var encodedImage;
  final ImagePicker _picker = ImagePicker();

  final name = TextEditingController();
  final email = TextEditingController();
  final number = TextEditingController();
  final address = TextEditingController();
  final country = TextEditingController();
  final skills = TextEditingController();
  final price = TextEditingController();
  final cat = TextEditingController();

  bool updateAble = false;
  bool loading = true;
  String imageURL = "";

  ProfileViewModel profileViewModel = Get.put(ProfileViewModel());

  @override
  void initState() {
    super.initState();
    GetAddressFromLatLong(
        lat: profileViewModel.userList[0].coordinates[0],
        long: profileViewModel.userList[0].coordinates[1]);
    setState(() {
      email.text = profileViewModel.userList[0].email;
      name.text = profileViewModel.userList[0].name;
      number.text = profileViewModel.userList[0].phoneNumber;
      skills.text = profileViewModel.userList[0].skills;
      price.text = profileViewModel.userList[0].price.toString();
      cat.text = profileViewModel.userList[0].Category.toString();
      imageURL = profileViewModel.userList[0].userImage;
      loading = false;
    });
  }

  Future<void> GetAddressFromLatLong({
    required double lat,
    required double long,
  }) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
    print(placemarks);
    Placemark place = placemarks[0];
    setState(() {
      address.text = '${place.subLocality} ${place.locality}';
      country.text = '${place.country}';
    });
    print("latitue");
    print(lat);
    print(long);
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
              backgroundColor: AppColors.mainColor,
              title: TextView(text: "Profile"),
            )
          : null,
      body: loading
          ? Center(
              child: SpinKitThreeBounce(
                color: AppColors.mainColor,
                size: MediaQuery.of(context).size.width / 8,
              ),
            )
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              width: Dimensions.screenWidth(context),
              height: Dimensions.screenHeight(context),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    AddVerticalSpace(30),
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
                              errorWidget: (context, url, error) => Icon(
                                Icons.error,
                                color: AppColors.white,
                              ),
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
                    AddVerticalSpace(50),
                    TextEditField(
                      preffixIcon: Icon(Icons.person),
                      hintText: "Name",
                      textEditingController: name,
                      onChanged: (value) async {
                        DocumentSnapshot snapshot = await FirebaseFirestore
                            .instance
                            .collection("users")
                            .doc(profileViewModel.userList[0].email)
                            .get();

                        setState(() {
                          value == (snapshot.data() as dynamic)["name"]
                              ? updateAble = false
                              : updateAble = true;
                        });
                      },
                      width: Dimensions.screenWidth(context),
                    ),
                    AddVerticalSpace(20),
                    TextEditField(
                      width: Dimensions.screenWidth(context),
                      preffixIcon: Icon(Icons.email),
                      hintText: "Email",
                      textEditingController: email,
                      readOnly: true,
                    ),
                    AddVerticalSpace(20),
                    TextEditField(
                      width: Dimensions.screenWidth(context),
                      preffixIcon: Icon(Icons.phone),
                      hintText: "Phone Number",
                      textEditingController: number,
                      onChanged: (value) async {
                        DocumentSnapshot snapshot = await FirebaseFirestore
                            .instance
                            .collection("users")
                            .doc(profileViewModel.userList[0].email)
                            .get();
                        setState(() {
                          value == (snapshot.data() as dynamic)["phoneNumber"]
                              ? updateAble = false
                              : updateAble = true;
                        });
                      },
                    ),
                    profileViewModel.userList.value[0].type == 1
                        ? AddVerticalSpace(20)
                        : SizedBox(),
                    profileViewModel.userList.value[0].type == 1
                        ?TextEditField(
                      width: Dimensions.screenWidth(context),
                      preffixIcon: Icon(Icons.work_outline),
                      onChanged: (value) async {
                        DocumentSnapshot snapshot = await FirebaseFirestore
                            .instance
                            .collection("users")
                            .doc(profileViewModel.userList[0].email)
                            .get();
                        setState(() {
                          value == (snapshot.data() as dynamic)["skills"]
                              ? updateAble = false
                              : updateAble = true;
                        });
                      },
                      hintText: "Skills",
                      textEditingController: skills,
                    ):SizedBox(),
                    profileViewModel.userList.value[0].type == 1
                        ? AddVerticalSpace(20)
                        : SizedBox(),
                    profileViewModel.userList.value[0].type == 1
                        ?TextEditField(
                      width: Dimensions.screenWidth(context),
                      preffixIcon: Icon(Icons.money),
                      hintText: "Price /day",
                      onChanged: (value) async {
                        DocumentSnapshot snapshot = await FirebaseFirestore
                            .instance
                            .collection("users")
                            .doc(profileViewModel.userList[0].email)
                            .get();
                        setState(() {
                          value == (snapshot.data() as dynamic)["price"]
                              ? updateAble = false
                              : updateAble = true;
                        });
                      },
                      textEditingController: price,
                    ):SizedBox(),
                    profileViewModel.userList.value[0].type == 1
                        ? AddVerticalSpace(20)
                        : SizedBox(),
                    profileViewModel.userList.value[0].type == 1
                        ?TextEditField(
                      readOnly: true
                      ,
                      width: Dimensions.screenWidth(context),
                      preffixIcon: Icon(Icons.category_outlined),
                      hintText: "Category",
                      onChanged: (value) async {
                        DocumentSnapshot snapshot = await FirebaseFirestore
                            .instance
                            .collection("users")
                            .doc(profileViewModel.userList[0].email)
                            .get();
                        setState(() {
                          value == (snapshot.data() as dynamic)["Category"]
                              ? updateAble = false
                              : updateAble = true;
                        });
                      },
                      textEditingController: cat,
                    ):SizedBox(),
                    AddVerticalSpace(20),
                    TextEditField(
                      width: Dimensions.screenWidth(context),
                      preffixIcon: Icon(Icons.location_on),
                      hintText: "Address",
                      textEditingController: address,
                      readOnly: true,
                    ),
                    AddVerticalSpace(20),
                    TextEditField(
                      width: Dimensions.screenWidth(context),
                      preffixIcon: Icon(Icons.account_balance_rounded),
                      hintText: "Country",
                      readOnly: true,
                      textEditingController: country,
                    ),
                    AddVerticalSpace(40),
                    updateAble
                        ? BTN(
                            title: "Update",
                            textColor: AppColors.white,
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(email.text)
                                  .update({
                                "name": name.text,
                                "phoneNumber": number.text,
                                "userImage": imageURL,
                                "skills": skills.text,
                                "price":int.parse(price.text),
                              });
                              setState(() {
                                updateAble = false;
                              });
                            },
                            width: 200,
                            color: AppColors.mainColor,
                          )
                        : SizedBox(),
                    AddVerticalSpace(30),
                  ],
                ),
              ),
            ),
    );
  }
}
