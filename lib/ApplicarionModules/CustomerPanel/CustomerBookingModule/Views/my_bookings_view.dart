import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '../../../../Utils/app_colors.dart';
import '../../../../Utils/dimensions.dart';
import '../../../../Utils/text_view.dart';
import '../../../CustomerPanel/CustomerBookingModule/Models/booking_model.dart';
import '../../../WorkerPanel/WorkerBookingModule/ViewModels/worker_booking_model.dart';
import 'Components/customer_booking_list_item.dart';

class CustomerBookingListView extends StatefulWidget {
  @override
  State<CustomerBookingListView> createState() =>
      _CustomerBookingListViewState();
}

class _CustomerBookingListViewState extends State<CustomerBookingListView> {
  WorkerBoookingViewModel workerViewModel = Get.put(WorkerBoookingViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        title: TextView(text: "My Bookings"),
      ),
      body: Container(
        height: Dimensions.screenHeight(context),
        padding: EdgeInsets.only(top: 10),
        child: FutureBuilder(
            future: workerViewModel.getCustomerBooking(),
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
                      itemCount:
                          workerViewModel.customerbookingList.value.length,
                      itemBuilder: (context, index) {
                        var data =
                            workerViewModel.customerbookingList.value[index];
                        return CustomerBookingListItem(
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
                            address: data.address, customerAdress: data.customerAdress,
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
