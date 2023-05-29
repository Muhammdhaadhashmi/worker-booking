import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:worker_booking/ApplicarionModules/AuthenticationModule/Views/sign_in_view.dart';
import 'package:worker_booking/ApplicarionModules/ChatModule/Views/inbox_view.dart';
import 'package:worker_booking/ApplicarionModules/ProfileModule/Views/profile_view.dart';
import '../../../Utils/app_colors.dart';
import '../../../Utils/spaces.dart';
import '../../../Utils/text_view.dart';
import '../../AuthenticationModule/Views/usertype_selection_view.dart';
import '../../CustomerPanel/CustomerBookingModule/Views/my_bookings_view.dart';
import '../../ProfileModule/ViewModels/profile_view_model.dart';
import 'drawer_tile.dart';

class DrawerView extends StatefulWidget {
  const DrawerView({Key? key}) : super(key: key);

  @override
  State<DrawerView> createState() => _DrawerViewState();
}

class _DrawerViewState extends State<DrawerView> {
  ProfileViewModel pVM = Get.put(ProfileViewModel());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pVM.getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Drawer(
      elevation: 10,
      child: Container(
        color: AppColors.white,
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(color: AppColors.mainColor),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 200,
                    padding: EdgeInsets.only(left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        AddVerticalSpace(55),
                        Container(
                          // height: 80,
                          // width: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.mainColor,
                          ),
                          child: Container(
                            height: 60,
                            width: 60,
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.white,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: OptimizedCacheImage(
                                imageUrl: pVM.userList.value[0].userImage,
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) => Center(
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
                        ),
                        AddVerticalSpace(10),
                        TextView(
                          text: "${pVM.userList.value[0].name}",
                          color: AppColors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        AddVerticalSpace(5),
                        TextView(
                          text: pVM.userList.value[0].email,
                          color: AppColors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            AddVerticalSpace(10),
            DrawerTile(
              onTap: () {
                Get.to(
                  ProfileView(showAppBar: true),
                  transition: Transition.rightToLeft,
                  duration: Duration(milliseconds: 600),
                );
              },
              icon: Icons.person_outline_outlined,
              title: "Profile",
            ),
            AddVerticalSpace(1),
            DrawerTile(
              onTap: () {
                Get.to(
                  InboxView(),
                  transition: Transition.rightToLeft,
                  duration: Duration(milliseconds: 600),
                );
              },
              icon: Icons.message_outlined,
              title: "Inbox",
            ),
            AddVerticalSpace(1),
            pVM.userList[0].type == 0
                ? DrawerTile(
                    onTap: () {
                      Get.to(
                        CustomerBookingListView(),
                        transition: Transition.rightToLeft,
                        duration: Duration(milliseconds: 600),
                      );
                    },
                    icon: Icons.shopping_bag_outlined,
                    title: "My Bookings",
                  )
                : SizedBox(),
            AddVerticalSpace(1),

            // DrawerTile(
            //   onTap: () {},
            //   icon: Icons.privacy_tip_outlined,
            //   title: "Privacy Policy",
            // ),
            // AddVerticalSpace(1),
            DrawerTile(
              onTap: () async {
                await FirebaseFirestore.instance
                    .collection("users")
                    .doc(FirebaseAuth.instance.currentUser!.email)
                    .update({
                  "FCMToken": "",
                });
                await FirebaseAuth.instance.signOut();
                Get.offAll(
                  UsertypeSelectionView(),
                  transition: Transition.rightToLeft,
                  duration: Duration(milliseconds: 600),
                );
              },
              icon: Icons.logout,
              title: "Log Out",
            ),
          ],
        ),
      ),
    ));
  }
}
