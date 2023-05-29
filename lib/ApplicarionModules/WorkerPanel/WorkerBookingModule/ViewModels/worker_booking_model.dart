import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:worker_booking/ApplicarionModules/CustomerPanel/CustomerBookingModule/Models/booking_model.dart';

class WorkerBoookingViewModel extends GetxController {
  RxList<BookingModel> bookingList = <BookingModel>[].obs;
  RxList<BookingModel> customerbookingList = <BookingModel>[].obs;

  getBookings({required String status}) async {
    // bookingList.value.clear();
    await FirebaseFirestore.instance
        .collection("bookings")
        .snapshots()
        .listen((event) {
      bookingList.value = BookingModel.jsonToListView(event.docs)
          .where((element) =>
              element.workerEmail == FirebaseAuth.instance.currentUser!.email &&
              element.bookingStatus == status).toList();
    });
  }



  getCustomerBooking() async {
    await FirebaseFirestore.instance
        .collection("bookings")
        .snapshots()
        .listen((event) {
      customerbookingList.value = BookingModel.jsonToListView(event.docs)
          .where((element) =>
              element.customerEmail == FirebaseAuth.instance.currentUser!.email)
          .toList();
    });
  }
}
