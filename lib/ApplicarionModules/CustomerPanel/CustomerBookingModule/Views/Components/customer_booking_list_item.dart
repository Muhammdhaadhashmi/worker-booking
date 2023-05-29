import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:worker_booking/ApplicarionModules/CustomerPanel/CustomerBookingModule/Models/rate_model.dart';

import '../../../../../Utils/app_colors.dart';
import '../../../../../Utils/btn.dart';
import '../../../../../Utils/dimensions.dart';
import '../../../../../Utils/spaces.dart';
import '../../../../../Utils/text_view.dart';
import '../../../../CustomerPanel/CustomerBookingModule/Models/booking_model.dart';
import '../../../../WorkerPanel/WorkerBookingModule/Views/booking_detail_view.dart';

class CustomerBookingListItem extends StatefulWidget {
  final BookingModel bookingModel;

  const CustomerBookingListItem({
    Key? key,
    required this.bookingModel,
  }) : super(key: key);

  @override
  State<CustomerBookingListItem> createState() =>
      _CustomerBookingListItemState();
}

class _CustomerBookingListItemState extends State<CustomerBookingListItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {

        Get.to(
          BookingDetailView(bookingModel: widget.bookingModel),
          transition: Transition.rightToLeft,
          duration: Duration(milliseconds: 600),
        );
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
                TextView(
                  text: "Name : ${widget.bookingModel.workerName}",
                  fontSize: 18,
                ),
                AddVerticalSpace(5),
                TextView(
                  text: "Status : ${widget.bookingModel.bookingStatus}",
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
                widget.bookingModel.paid == 0
                    ? Center(
                        child: BTN(
                          title: "Paid & Review",
                          color: AppColors.mainColor,
                          textColor: AppColors.white,
                          width: Dimensions.screenWidth(context) / 2,
                          onPressed: () async {
                            showRatingDialog();
                          },
                        ),
                      )
                    : SizedBox()
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showRatingDialog() {
    final _dialog = RatingDialog(
      initialRating: 1.0,
      // your app's name?
      title: Text(
        'Rate Worker',
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
      // encourage your user to leave a high rating?
      message: Text(
        'Set the Rating of Worker.',
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 15),
      ),
      // your app's logo?
      image: Image.asset(
        "assets/Images/logo.png",
        height: 150,
        width: 150,
      ),
      submitButtonText: 'Rate',
      commentHint: 'Add Comments',
      onCancelled: () => print('cancelled'),
      onSubmitted: (response) async {
        int time = DateTime.now().microsecondsSinceEpoch;

        RateModel rateModel = RateModel(
          customerName: widget.bookingModel.customerName,
          workerName: widget.bookingModel.workerName,
          time: time,
          customerEmail: widget.bookingModel.customerEmail,
          workerEmail: widget.bookingModel.workerEmail,
          rate: "${response.rating}",
          comment: "${response.comment}",
          isreview: true,
        );
        await FirebaseFirestore.instance
            .collection("ratings")
            //.doc("${widget.bookingModel.workerEmail}")
            .doc("${time}")
            .set(
              rateModel.toJson(),
            );

        await FirebaseFirestore.instance
            .collection("bookings")
            .doc(widget.bookingModel.time.toString())
            .update({"paid": 1});

        await FirebaseFirestore.instance
            .collection("bookings")
            .doc(widget.bookingModel.time.toString())
            .update({"bookingStatus": "paid"});

        await FirebaseFirestore.instance
            .collection("users")
            .doc(widget.bookingModel.workerEmail.toString())
            .update({"ocupied": 0});
      },
    );

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: true, // set to false if you want to force a rating
      builder: (context) => _dialog,
    );
  }
}
