import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  int time;
  String customerName;
  String workerName;
  String customerEmail;
  String customerPhoneNumber;
  String customerAdress;
  String description;
  String address;
  String from;
  String to;
  int days;
  int price;

  String bookingStatus;
  String workerEmail;
  int paid;
  List<dynamic> coordinates;

  BookingModel({

    required this.customerAdress,
    required this.customerName,
    required this.workerName,
    required this.time,
    required this.customerEmail,
    required this.from,
    required this.to,
    required this.customerPhoneNumber,
    required this.description,
    required this.address,
    required this.days,
    required this.price,
    required this.bookingStatus,
    required this.workerEmail,
    required this.coordinates,
    required this.paid,
  });

  Map<String, dynamic> toJson() {
    return {

      'customerAddress': customerAdress,
      'customerName': customerName,
      'workerName': workerName,
      'time': time,
      'customerEmail': customerEmail,
      'from': from,
      'to': to,
      'customerPhoneNumber': customerPhoneNumber,
      'description': description,
      'address': address,
      'bookingStatus': bookingStatus,
      'workerEmail': workerEmail,
      'coordinates': coordinates,
      'days': days,
      'price': price,
      "paid": paid
    };
  }

  factory BookingModel.fromJson(DocumentSnapshot doc) => BookingModel(
        time: (doc.data() as dynamic)["time"] ?? 0,
        customerAdress: (doc.data() as dynamic)["customerAddress"] ?? "",
        price: (doc.data() as dynamic)["price"] ?? 0,
        customerName: (doc.data() as dynamic)["customerName"] ?? "",
        workerName: (doc.data() as dynamic)["workerName"] ?? "",
        customerEmail: (doc.data() as dynamic)["customerEmail"] ?? "",
        from: (doc.data() as dynamic)["from"] ?? "",
        days: (doc.data() as dynamic)["days"] ?? "",
        to: (doc.data() as dynamic)["to"] ?? 0,
        bookingStatus: (doc.data() as dynamic)["bookingStatus"] ?? "",
        customerPhoneNumber:
            (doc.data() as dynamic)["customerPhoneNumber"] ?? "",
        description: (doc.data() as dynamic)["description"] ?? "",
        address: (doc.data() as dynamic)["address"] ?? "",
        workerEmail: (doc.data() as dynamic)["workerEmail"] ?? "",
        paid: (doc.data() as dynamic)["paid"] ?? 0,
        coordinates: (doc.data() as dynamic)["coordinates"] ?? [],
      );

  static List<BookingModel> jsonToListView(List<DocumentSnapshot> snapshot) {
    return snapshot.map((e) => BookingModel.fromJson(e)).toList();
  }
}
