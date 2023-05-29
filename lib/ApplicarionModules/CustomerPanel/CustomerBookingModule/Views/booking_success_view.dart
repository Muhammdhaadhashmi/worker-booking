import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:worker_booking/ApplicarionModules/SearchModule/Views/search_view.dart';

import '../../../../Utils/app_colors.dart';
import '../../../../Utils/btn.dart';
import '../../../../Utils/dimensions.dart';
import '../../../../Utils/spaces.dart';
import '../../../../Utils/text_view.dart';
import '../../WorkerModule/Views/workers_list_view.dart';

class BookingSuccessView extends StatefulWidget {
  const BookingSuccessView({Key? key}) : super(key: key);

  @override
  State<BookingSuccessView> createState() => _BookingSuccessViewState();
}

class _BookingSuccessViewState extends State<BookingSuccessView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: Container(
        height: Dimensions.screenHeight(context),
        width: Dimensions.screenWidth(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_done_outlined,
              size: 130,
              color: AppColors.white,
            ),
            TextView(
              text: "Success!",
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
            AddVerticalSpace(20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: TextView(
                text: "SuccessFully Booked",
                textAlign: TextAlign.center,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10.0),
        child: BTN(
          title: "Done",
          color: Colors.lightGreen,
          textColor: AppColors.white,
          onPressed: () {
            Get.offAll(
              SearchView(),
              //WorkersListView(),
              transition: Transition.rightToLeft,
              duration: Duration(milliseconds: 600),
            );
          },
          width: Dimensions.screenWidth(context),
        ),
      ),
    );
  }
}
