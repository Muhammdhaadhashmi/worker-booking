import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String name;
  String email;
  String address;
  String city;
  String skills;
  String phoneNumber;
  int type;
  List<dynamic> coordinates;
  String FCMToken;
  String experience;
  int allOrders;
  int completedOrders;
  int price;
  int ocupied;
  String userImage;
  String Category;

  UserModel({
    required this.name,
    required this.email,
    required this.price,
    required this.type,
    required this.coordinates,
    required this.address,
    required this.city,
    required this.skills,
    required this.phoneNumber,
    required this.FCMToken,
    required this.experience,
    required this.allOrders,
    required this.completedOrders,
    required this.userImage,
    required this.ocupied,
    required this.Category,

  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'price': price,
      'type': type,
      'coordinates': coordinates,
      'address': address,
      'city': city,
      'skills': skills,
      'phoneNumber': phoneNumber,
      'FCMToken': FCMToken,
      'experience': experience,
      'allOrders': allOrders+2,
      'completedOrders': completedOrders+1,
      'userImage': userImage,
      'ocupied': ocupied,
      'Category': Category,
    };
  }
  factory UserModel.fromJson(DocumentSnapshot doc) => UserModel(
    name: (doc.data() as dynamic)["name"] ?? "N/A",
    email: (doc.data() as dynamic)["email"] ?? "N/A",
    price: (doc.data() as dynamic)["price"] ?? 0,
    type: (doc.data() as dynamic)["type"] ?? 0,
    coordinates: (doc.data() as dynamic)["coordinates"] ?? [],
    address: (doc.data() as dynamic)["address"] ?? "",
    city: (doc.data() as dynamic)["city"] ?? "N/A",
    skills: (doc.data() as dynamic)["skills"] ?? "N/A",
    phoneNumber: (doc.data() as dynamic)["phoneNumber"] ?? "N/A",
    FCMToken: (doc.data() as dynamic)["FCMToken"] ?? "N/A",
    experience: (doc.data() as dynamic)["experience"] ?? "N/A",
    allOrders: (doc.data() as dynamic)["allOrders"] ?? 0,
    completedOrders: (doc.data() as dynamic)["completedOrders"] ?? 0,
    userImage: (doc.data() as dynamic)["userImage"] ?? "N/A",
    ocupied: (doc.data() as dynamic)["ocupied"] ?? 0,
    Category: (doc.data() as dynamic)["Category"] ?? "",
  );
  static List<UserModel> jsonToListView(List<DocumentSnapshot> snapshot){

    return snapshot.map((e) => UserModel.fromJson(e)).toList();
  }

}

