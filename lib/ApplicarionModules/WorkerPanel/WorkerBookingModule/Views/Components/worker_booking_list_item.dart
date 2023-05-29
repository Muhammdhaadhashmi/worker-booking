import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../Utils/app_colors.dart';
import '../../../../../Utils/btn.dart';
import '../../../../../Utils/dimensions.dart';
import '../../../../../Utils/spaces.dart';
import '../../../../../Utils/text_view.dart';
import '../../../../CustomerPanel/CustomerBookingModule/Models/booking_model.dart';
import '../booking_detail_view.dart';

class WorkerBookingListItem extends StatefulWidget {

  final BookingModel bookingModel;
  final sum;

  const WorkerBookingListItem({
    Key? key,
    required this.bookingModel, this.sum,
  }) : super(key: key);

  @override
  State<WorkerBookingListItem> createState() => _WorkerBookingListItemState();
}

class _WorkerBookingListItemState extends State<WorkerBookingListItem> {


  bool val=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print(widget.sum);



  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Get.to(
        //   BookingDetailView(bookingModel: widget.bookingModel),
        //   transition: Transition.rightToLeft,
        //   duration: Duration(milliseconds: 600),
        // );
      },
      child: Container(
        width: Dimensions.screenWidth(context),
        margin: EdgeInsets.only(bottom: 10, right: 20, left: 20),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.cat_back,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(color: AppColors.grey, blurRadius: 3),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: Dimensions.screenWidth(context) / 1.5,
                  child: TextView(
                    text: "Date and Day : ${widget.bookingModel.from}",
                    fontSize: 16,
                  ),
                ),
                AddVerticalSpace(5),
                TextView(
                  // text: "Category : Engine Work",
                  text: "Working Hours : ${widget.bookingModel.days} ",
                  fontSize: 18,
                ),
                AddVerticalSpace(5),
                TextView(
                  // text: "Category : Engine Work",
                  text: "Booked By : ${widget.bookingModel.customerName} ",
                  fontSize: 18,
                ),
                AddVerticalSpace(5),
                TextView(
                  text: "Name : ${widget.bookingModel.workerName}",
                  fontSize: 18,
                ),
                AddVerticalSpace(5),
                TextView(
                  text: "Status : ${widget.bookingModel.bookingStatus}",
                  fontSize: 18,
                ),
                TextView(
                  text:
                      "Customer Address : ${widget.bookingModel.customerAdress}",
                  fontSize: 18,
                ),
                AddVerticalSpace(5),
                TextView(
                  // text: "Category : Engine Work",
                  text: "Description : ${widget.bookingModel.description}",
                  fontSize: 18,
                ),
                AddVerticalSpace(5),
                TextView(
                  text:
                      "Time : ${DateFormat.jm().format(DateTime.fromMicrosecondsSinceEpoch(widget.bookingModel.time))}",
                  fontSize: 18,
                ),
                AddVerticalSpace(10),
                TextView(
                  // text: "Category : Engine Work",
                  text:
                      "Total Bill : ${widget.bookingModel.days * widget.bookingModel.price} Rs",
                  fontSize: 18,
                ),
         
              ],
            ),
          ],
        ),
      ),
    );
  }
}
