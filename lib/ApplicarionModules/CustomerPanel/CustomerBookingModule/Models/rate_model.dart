import 'package:cloud_firestore/cloud_firestore.dart';

class RateModel {
  int time;
  String customerName;
  String workerName;
  String customerEmail;
  String workerEmail;
  String rate;
  String comment;
  bool isreview;

  RateModel({
    required this.customerName,
    required this.workerName,
    required this.time,
    required this.customerEmail,
    required this.workerEmail,
    required this.rate,
    required this.comment,
    required this.isreview,

  });

  Map<String, dynamic> toJson() {
    return {
      'customerName': customerName,
      'workerName': workerName,
      'time': time,
      'customerEmail': customerEmail,
      'workerEmail': workerEmail,
      "rate":rate,
      "comment":comment,
      "isreview":isreview,
    };
  }

  factory RateModel.fromJson(DocumentSnapshot doc) => RateModel(
    time: (doc.data() as dynamic)["time"] ?? 0,
    customerName: (doc.data() as dynamic)["customerName"] ?? "",
    workerName: (doc.data() as dynamic)["workerName"] ?? "",
    customerEmail: (doc.data() as dynamic)["customerEmail"] ?? "",
    rate: (doc.data() as dynamic)["rate"] ?? "",
    workerEmail: (doc.data() as dynamic)["workerEmail"] ?? "",
    comment: (doc.data() as dynamic)["comment"] ??"",
    isreview: (doc.data() as dynamic)["isreview"] ?? false,
  );

  static List<RateModel> jsonToListView(List<DocumentSnapshot> snapshot) {
    return snapshot.map((e) => RateModel.fromJson(e)).toList();
  }
}