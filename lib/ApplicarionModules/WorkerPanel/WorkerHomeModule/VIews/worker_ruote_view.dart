import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:worker_booking/ApplicarionModules/DrawerModule/Views/drawer_view.dart';
import 'package:worker_booking/ApplicarionModules/ProfileModule/Views/profile_view.dart';
import 'package:worker_booking/ApplicarionModules/WorkerPanel/WorkerBookingModule/Views/worker_booking_list_view.dart';

import '../../../../Utils/app_colors.dart';
import '../../../../Utils/text_view.dart';
import '../../../ProfileModule/ViewModels/profile_view_model.dart';

class WorkerRouteView extends StatefulWidget {
  const WorkerRouteView({Key? key}) : super(key: key);

  @override
  State<WorkerRouteView> createState() => _WorkerRouteViewState();
}

class _WorkerRouteViewState extends State<WorkerRouteView> {
  List selectedIcons = [
    Icons.request_page,
    Icons.history,
    Icons.person,
  ];
  List unselectedIcons = [
    Icons.request_page_outlined,
    Icons.history_outlined,
    Icons.person_outline,
  ];
  List text = [
    "Bookings",
    "History",
    "Profile",
  ];
  int currentindex = 0;
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
      drawer: DrawerView(),
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        title: TextView(
            text: currentindex == 0
                ? "Bookings"
                : currentindex == 1
                    ? "History"
                    : "Profile"),
      ),
      body: [
        WorkerBookingListView(currentIndex: currentindex),
        WorkerBookingListView(currentIndex: currentindex),
        ProfileView(showAppBar: false),
      ].elementAt(currentindex),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: AppColors.grey,
        selectedItemColor: AppColors.mainColor,
        currentIndex: currentindex,
        onTap: (value) {
          setState(() {
            currentindex = value;
          });
        },
        items: [
          for (int i = 0; i < selectedIcons.length; i++)
            BottomNavigationBarItem(
                icon: Icon(
                    currentindex == i ? selectedIcons[i] : unselectedIcons[i]),
                label: "${text[i]}"),
        ],
      ),
    );
  }
}
