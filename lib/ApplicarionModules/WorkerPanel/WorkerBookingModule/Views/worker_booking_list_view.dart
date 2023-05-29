import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '../../../../Utils/app_colors.dart';
import '../../../../Utils/dimensions.dart';
import '../../../CustomerPanel/CustomerBookingModule/Models/booking_model.dart';
import '../ViewModels/worker_booking_model.dart';
import 'Components/worker_booking_list_item.dart';

class WorkerBookingListView extends StatefulWidget {
  final int currentIndex;

  const WorkerBookingListView({super.key, required this.currentIndex});

  @override
  State<WorkerBookingListView> createState() => _WorkerBookingListViewState();
}

class _WorkerBookingListViewState extends State<WorkerBookingListView> {
  WorkerBoookingViewModel workerViewModel = Get.put(WorkerBoookingViewModel());

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Dimensions.screenHeight(context),
        padding: EdgeInsets.only(top: 10),
        child: FutureBuilder(
            future: workerViewModel.getBookings(
                //status: widget.currentIndex == 0 ? "Booked" : "Checked"),
                status: widget.currentIndex == 0 ? "Booked" : "paid"),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: SpinKitThreeBounce(
                    color: AppColors.mainColor,
                    size: MediaQuery.of(context).size.width / 8,
                  ),
                );
              }
              return CupertinoScrollbar(
                child: Obx(() => ListView.builder(
                      itemCount: workerViewModel.bookingList.value.length,
                      itemBuilder: (context, index) {
                        var data = workerViewModel.bookingList.value[index];
                        int sum = 0;
                        sum = sum + data.price * data.days;
                        return WorkerBookingListItem(
                          sum: sum,
                          bookingModel: BookingModel(
                            price: data.price,
                            days: data.days,
                            customerName: data.customerName,
                            workerName: data.workerName,
                            time: data.time,
                            customerEmail: data.customerEmail,
                            from: data.from,
                            to: data.to,
                            customerPhoneNumber: data.customerPhoneNumber,
                            description: data.description,
                            bookingStatus: data.bookingStatus,
                            workerEmail: data.workerEmail,
                            coordinates: data.coordinates, paid: data.paid,
                            address: data.address,
                            customerAdress: data.customerAdress,
                            // address:data.address,
                          ),
                        );
                      },
                    )),
              );
            }),
      ),
    );
  }
}
