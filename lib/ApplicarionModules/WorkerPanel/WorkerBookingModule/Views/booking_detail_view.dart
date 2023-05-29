import 'dart:ui';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:worker_booking/ApplicarionModules/CustomerPanel/CustomerBookingModule/Models/booking_model.dart';
import 'package:worker_booking/ApplicarionModules/CustomerPanel/WorkerModule/Views/worker_detail_view.dart';
import 'package:worker_booking/ApplicarionModules/ProfileModule/Models/user_model.dart';

import '../../../../Utils/app_colors.dart';
import '../../../../Utils/btn.dart';
import '../../../../Utils/dimensions.dart';
import '../../../../Utils/spaces.dart';
import '../../../../Utils/text_edit_field.dart';
import '../../../../Utils/text_view.dart';
import '../../../ChatModule/Services/chat_service.dart';
import '../../../ProfileModule/ViewModels/profile_view_model.dart';

class BookingDetailView extends StatefulWidget {
  final BookingModel bookingModel;

  const BookingDetailView({super.key, required this.bookingModel});

  @override
  State<BookingDetailView> createState() => _BookingDetailViewState();
}

class _BookingDetailViewState extends State<BookingDetailView> {
  ProfileViewModel pVM = Get.put(ProfileViewModel());

  bool loading = false;

  TextEditingController from = TextEditingController();
  TextEditingController des = TextEditingController();
  // TextEditingController add = TextEditingController();
  List<UserModel> users = [];

  // List<UserModel> users = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    from.text =widget.bookingModel.from;

    des.text = widget.bookingModel.description;
    if (pVM.userList.value[0].type == 0) {
      print("workerEmail");
      print(widget.bookingModel.workerEmail);

      users = pVM.allUserList.value
          .where((element) => element.email == widget.bookingModel.workerEmail)
          .toList();
    } else {
      print("customerEmail");
      print(widget.bookingModel.customerEmail);
      users = pVM.allUserList.value
          .where(
              (element) => element.email == widget.bookingModel.customerEmail)
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    double blur = loading ? 5 : 0;

    return Stack(
      children: [
        ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Scaffold(
            body: Container(
              height: Dimensions.screenHeight(context),
              width: Dimensions.screenWidth(context),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AddVerticalSpace(50),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 45,
                              width: 45,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.mainColor,
                              ),
                              child: Icon(
                                Icons.chevron_left,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                          // AddHorizontalSpace(10),
                          TextView(
                            text: "SUMMARY",
                            color: AppColors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.to(
                                WorkerDetailsView(
                                  forBooking: false,
                                  userModel: UserModel(
                                    name: users[0].name,
                                    email: users[0].email,
                                    price: users[0].price,
                                    type: users[0].type,
                                    coordinates: users[0].coordinates,
                                    address: users[0].address,
                                    city: users[0].city,
                                    skills:users[0]. skills,
                                    phoneNumber:users[0]. phoneNumber,
                                    FCMToken: users[0].FCMToken,
                                    experience:users[0]. experience,
                                    allOrders:users[0]. allOrders,
                                    completedOrders:users[0]. completedOrders,
                                    userImage: users[0].userImage,
                                    ocupied: users[0].ocupied,
                                    Category: users[0].Category,
                                  ),
                                ),
                                transition: Transition.rightToLeft,
                                duration: Duration(milliseconds: 600),
                              );
                            },
                            child: Container(
                              height: 45,
                              width: 45,
                              padding: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.mainColor,
                              ),
                              child: ClipOval(
                                child: OptimizedCacheImage(
                                  imageUrl: users[0].userImage,
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) =>
                                      Container(
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
                          ),
                        ],
                      ),
                    ),
                    AddVerticalSpace(40),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      // height: 65,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextView(
                            text: "From",
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                          TextEditField(
                            hintText: "From",
                            readOnly: true,
                            textEditingController: from,
                            hintSize: 14,
                            cursorColor: AppColors.mainColor,
                            width: Dimensions.screenWidth(context),
                          ),

                        ],
                      ),
                    ),
                    AddVerticalSpace(40),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextView(
                            text:
                            "${widget.bookingModel.days} Hours in Working Period",
                            color: AppColors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        AddVerticalSpace(16),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: TextView(
                            text: "Fee & Tax Details",
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        AddVerticalSpace(16),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  TextView(
                                    text:
                                    "${widget.bookingModel.price} x ${widget.bookingModel.days} Hours",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  TextView(
                                    text:
                                    "${widget.bookingModel.price * widget.bookingModel.days}",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ],
                              ),
                              AddVerticalSpace(16),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  TextView(
                                    text: "Service charges",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  TextView(
                                    text: "25",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ],
                              ),
                              AddVerticalSpace(22),
                              Divider(
                                height: 1,
                                color: AppColors.grey,
                              ),
                              AddVerticalSpace(17),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  TextView(
                                    text: "Total",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  TextView(
                                    text:
                                    "${(widget.bookingModel.price * widget.bookingModel.days) + 25} Rs",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ],
                              ),
                              AddVerticalSpace(25),

                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: TextEditField(
                            hintText: "Description",
                            hintSize: 14,
                            cursorColor: AppColors.mainColor,
                            textEditingController: des,
                            width: Dimensions.screenWidth(context),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: widget.bookingModel.customerEmail ==
                FirebaseAuth.instance.currentUser!.email
                ? SizedBox()
                : widget.bookingModel.bookingStatus == "Checked"
                ? SizedBox()
                : Padding(
              padding: const EdgeInsets.all(10.0),
              child: BTN(
                title: "Checked",
                color: AppColors.mainColor,
                textColor: AppColors.white,
                width: Dimensions.screenWidth(context),
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection("bookings")
                      .doc("${widget.bookingModel.time}")
                      .update({"bookingStatus": "Checked"});
                  Get.back();
                },
              ),
            ),
          ),
        ),
        loading
            ? Container(
          height: Dimensions.screenHeight(context),
          width: Dimensions.screenWidth(context),
          color: AppColors.transparent,
          child: Center(
            child: SpinKitThreeBounce(
              color: AppColors.mainColor,
              size: MediaQuery.of(context).size.width / 8,
            ),
          ),
        )
            : SizedBox(),
      ],
    );
  }
}
