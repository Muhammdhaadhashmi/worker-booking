import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:worker_booking/ApplicarionModules/DrawerModule/Views/drawer_view.dart';

import '../../../../Utils/app_colors.dart';
import '../../../../Utils/dimensions.dart';
import '../../../../Utils/spaces.dart';
import '../../../../Utils/text_view.dart';
import '../../../ProfileModule/ViewModels/profile_view_model.dart';
import 'Components/category_list_item.dart';

class CustomerHomeView extends StatefulWidget {
  const CustomerHomeView({Key? key}) : super(key: key);

  @override
  State<CustomerHomeView> createState() => _CustomerHomeViewState();
}

class _CustomerHomeViewState extends State<CustomerHomeView> {
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
        title: TextView(text: "Worker Booking"),
      ),
      body: Container(
        width: Dimensions.screenWidth(context),
        height: Dimensions.screenHeight(context),
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextView(
                text: "Good Morning!",
                color: AppColors.mainColor,
                fontSize: 20,
                fontWeight: FontWeight.w500),
            TextView(
                text: "We are glad to see you!",
                color: AppColors.mainColor,
                fontSize: 16),
            AddVerticalSpace(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextView(
                  text: "What type of vehicle services\nare you looking for?",
                  fontSize: 12,
                  color: AppColors.grey,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            AddVerticalSpace(20),
            Expanded(
              child: Container(
                // color: AppColors.mainColor,
                child: ListView.builder(
                  itemCount: category.length,
                  itemBuilder: (context, index) => CategoryListItem(
                    itemData: category[index],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List category = [
  {
    "cat_name": "Engine Works",
    "cat_img": "https://cdn-icons-png.flaticon.com/128/887/887219.png",
  },
  {
    "cat_name": "Body Works",
    "cat_img": "https://cdn-icons-png.flaticon.com/128/832/832902.png",
  },
  {
    "cat_name": "Maintainance",
    "cat_img": "https://cdn-icons-png.flaticon.com/128/6254/6254956.png",
  },
];
