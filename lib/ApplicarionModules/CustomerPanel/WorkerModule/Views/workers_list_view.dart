import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:worker_booking/ApplicarionModules/CustomerPanel/WorkerModule/ViewModels/woker_view_model.dart';
import 'package:worker_booking/ApplicarionModules/DrawerModule/Views/drawer_view.dart';
import 'package:worker_booking/ApplicarionModules/SearchModule/Views/search_view.dart';
import '../../../../Utils/app_colors.dart';
import '../../../../Utils/dimensions.dart';
import '../../../../Utils/text_view.dart';
import '../../../ProfileModule/Models/user_model.dart';
import '../../../ProfileModule/ViewModels/profile_view_model.dart';
import 'Components/worker_home_list_item.dart';

class WorkersListView extends StatefulWidget {
  const WorkersListView({Key? key}) : super(key: key);

  @override
  State<WorkersListView> createState() => _WorkersListViewState();
}

class _WorkersListViewState extends State<WorkersListView> {
  WorkerViewModel workerViewModel = Get.put(WorkerViewModel());

  ProfileViewModel profileViewModel = Get.put(ProfileViewModel());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    profileViewModel.getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        title: TextView(text: "Worker Booking"),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(
                SearchView(),
                transition: Transition.rightToLeft,
                duration: Duration(milliseconds: 600),
              );
            },
            icon: Icon(
              Icons.search,
            ),
          ),
        ],
      ),
      drawer: DrawerView(),
      // body: Container(
      //   width: Dimensions.screenWidth(context),
      //   height: Dimensions.screenHeight(context),
      //   padding: EdgeInsets.all(10),
      //   child: FutureBuilder(
      //       future: workerViewModel.getWorkers(),
      //       builder: (context, snapshot) {
      //         if (snapshot.connectionState == ConnectionState.waiting) {
      //           return Center(
      //             child: SpinKitThreeBounce(
      //               color: AppColors.mainColor,
      //               size: MediaQuery.of(context).size.width / 8,
      //             ),
      //           );
      //         }
      //
      //         return Obx(() => ListView.builder(
      //               itemCount: workerViewModel.workerList.value.length,
      //               itemBuilder: (context, index) {
      //                 var data = workerViewModel.workerList.value[index];
      //                 return WorkerHomeListItem(
      //                   userModel: UserModel(
      //                     name: data.name,
      //                     Category: data.Category,
      //                     email: data.email,
      //                     price: data.price,
      //                     type: data.type,
      //                     coordinates: data.coordinates,
      //                     address: data.address,
      //                     city: data.city,
      //                     skills: data.skills,
      //                     phoneNumber: data.phoneNumber,
      //                     FCMToken: data.FCMToken,
      //                     ocupied: data.ocupied,
      //                     experience: data.experience,
      //                     allOrders: data.allOrders,
      //                     completedOrders: data.completedOrders,
      //                     userImage: data.userImage,
      //                   ),
      //                 );
      //               },
      //             ));
      //       }),
      // ),


    );
  }
}
