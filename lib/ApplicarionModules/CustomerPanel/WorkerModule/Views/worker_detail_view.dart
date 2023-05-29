import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:worker_booking/ApplicarionModules/CustomerPanel/WorkerModule/Views/worker_ratings.dart';
import '../../../../Utils/app_colors.dart';
import '../../../../Utils/btn.dart';
import '../../../../Utils/dimensions.dart';
import '../../../../Utils/spaces.dart';
import '../../../../Utils/text_view.dart';
import '../../../ChatModule/Views/chat_view.dart';
import '../../../ProfileModule/Models/user_model.dart';
import '../../CustomerBookingModule/Views/booking_summary_view.dart';
import '../ViewModels/woker_view_model.dart';
import 'Components/contact_btn.dart';
import 'Components/worker_list_item.dart';
import 'Components/worker_orders.dart';

class WorkerDetailsView extends StatefulWidget {
  final UserModel userModel;
  final bool forBooking;

  const WorkerDetailsView({
    Key? key,
    required this.userModel,
    required this.forBooking,
  }) : super(key: key);

  @override
  State<WorkerDetailsView> createState() => _WorkerDetailsViewState();
}

class _WorkerDetailsViewState extends State<WorkerDetailsView> {
  WorkerViewModel workerViewModel = Get.put(WorkerViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        title: TextView(text: "Worker Details"),
      ),
      // drawer: CustomerDrawerView(),
      body: Container(
        width: Dimensions.screenWidth(context),
        height: Dimensions.screenHeight(context),
        child: SingleChildScrollView(
          child: Column(
            children: [
              AddVerticalSpace(30),
              Container(
                height: Dimensions.screenHeight(context) / 1.6,
                child: Stack(
                  children: [
                    Positioned(
                      top: 40,
                      right: 20,
                      left: 20,
                      child: Container(
                        padding: EdgeInsets.only(
                            top: 50, left: 20, right: 20, bottom: 40),
                        width: Dimensions.screenWidth(context),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(color: AppColors.grey, blurRadius: 3)
                          ],
                        ),
                        child: Column(
                          children: [
                            TextView(
                              text: widget.userModel.name,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            AddVerticalSpace(20),
                            TextView(
                              text: widget.userModel.Category,
                              fontSize: 14,
                            ),
                            AddVerticalSpace(20),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ContactBTN(
                                    icon: Icons.email_outlined,
                                    onTap: () async {
                                      await launchUrl(Uri.parse(
                                          "mailto:${widget.userModel.email}"));
                                    },
                                  ),
                                  AddHorizontalSpace(10),
                                  ContactBTN(
                                    icon: Icons.phone,
                                    onTap: () async {
                                      await launchUrl(Uri.parse(
                                          "tel:${widget.userModel.phoneNumber}"));
                                    },
                                  ),
                                ],
                              ),
                            ),
                            // WorkerOrder(
                            //     title: "Orders :",
                            //     num: widget.userModel.allOrders),

                            AddVerticalSpace(15),

                            AddVerticalSpace(30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                BTN(
                                  width:widget.forBooking? Dimensions.screenWidth(context) / 2.8:Dimensions.screenWidth(context)-80,
                                  color: AppColors.mainColor,
                                  title: "Inquire",
                                  textColor: AppColors.white,
                                  onPressed: () {
                                    Get.to(
                                      ChatView(userModel: widget.userModel),
                                      transition: Transition.rightToLeft,
                                      duration: Duration(milliseconds: 600),
                                    );
                                  },
                                ),
                               widget.forBooking? BTN(
                                  width: Dimensions.screenWidth(context) / 2.8,
                                  color: AppColors.mainColor,
                                  textColor: AppColors.white,
                                  title: "Book",
                                  onPressed: () {
                                    Get.to(
                                      BookingSummaryView(
                                          userModel: widget.userModel),
                                      transition: Transition.rightToLeft,
                                      duration: Duration(milliseconds: 600),
                                    );
                                  },
                                ):SizedBox(),

                              ],
                            ),

                            AddVerticalSpace(10),
                            BTN(
                              width:widget.forBooking? Dimensions.screenWidth(context) / 2.8:Dimensions.screenWidth(context)-80,
                              color: AppColors.mainColor,
                              title: "Ratings",
                              textColor: AppColors.white,
                              onPressed: () {
                                Get.to(
                                  RatingsView(email: widget.userModel.email,),
                                  transition: Transition.rightToLeft,
                                  duration: Duration(milliseconds: 600),
                                );
                              },
                            ),
                            AddVerticalSpace(10),
                          ],
                        ),
                      ),
                    ),

                    Positioned(
                      top: 0,
                      child: Container(
                        width: Dimensions.screenWidth(context),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 80,
                              width: 80,
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.white,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: OptimizedCacheImage(
                                  imageUrl: widget.userModel.userImage,
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) =>
                                      Center(
                                        child: CircularProgressIndicator(
                                          value: downloadProgress.progress,
                                          color: AppColors.mainColor,
                                        ),
                                      ),
                                  errorWidget: (context, url, error) => Icon(
                                    Icons.error,
                                    color: AppColors.mainColor,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Positioned(
                    //   top: 0,
                    //   child: Container(
                    //     width: Dimensions.screenWidth(context),
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: [
                    //         Container(
                    //           height: 80,
                    //           width: 80,
                    //           padding: EdgeInsets.all(2),
                    //           decoration: BoxDecoration(
                    //             shape: BoxShape.circle,
                    //             color: AppColors.white,
                    //           ),
                    //           child: ClipRRect(
                    //             borderRadius: BorderRadius.circular(100),
                    //             child: OptimizedCacheImage(
                    //               imageUrl: widget.userModel.userImage,
                    //               progressIndicatorBuilder:
                    //                   (context, url, downloadProgress) =>
                    //                       Center(
                    //                 child: CircularProgressIndicator(
                    //                   value: downloadProgress.progress,
                    //                   color: AppColors.mainColor,
                    //                 ),
                    //               ),
                    //               errorWidget: (context, url, error) => Icon(
                    //                 Icons.error,
                    //                 color: AppColors.mainColor,
                    //               ),
                    //               fit: BoxFit.cover,
                    //             ),
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
              widget.forBooking?  Container(
                height: 200,
                margin: EdgeInsets.all(20),
                child: FutureBuilder(
                    future: workerViewModel.getWorkers(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: SpinKitThreeBounce(
                            color: AppColors.mainColor,
                            size: MediaQuery.of(context).size.width / 8,
                          ),
                        );
                      }

                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: workerViewModel.workerList.value.length,
                        itemBuilder: (context, index) {
                          var data = workerViewModel.workerList.value[index];
                          return WokerListItem(
                            userModel: UserModel(
                              name: data.name,
                              Category: data.Category,
                              price: data.price,
                              email: data.email,
                              type: data.type,
                              coordinates: data.coordinates,
                              address: data.address,
                              ocupied: data.ocupied,
                              city: data.city,
                              skills: data.skills,
                              phoneNumber: data.phoneNumber,
                              FCMToken: data.FCMToken,
                              experience: data.experience,
                              allOrders: data.allOrders,
                              completedOrders: data.completedOrders,
                              userImage: data.userImage,
                            ),
                          );
                        },
                      );
                    }),
              ):SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
