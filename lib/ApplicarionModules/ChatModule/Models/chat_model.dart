import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  String   message;
  int time;
  bool isme;

  ChatModel({
    required this.time,
    required this.message,
    required this.isme,
  });

  factory ChatModel.fromJson(DocumentSnapshot snapshot) {
    return ChatModel(
      message: (snapshot.data() as dynamic)["message"] ?? " ",
      time: (snapshot.data() as dynamic)["time"] ?? 0,
      isme: (snapshot.data() as dynamic)["isMe"] ??false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "message": message,
      "time": time,
      "IsMe": isme,
    };
  }

  static List<ChatModel> JsonToListView(List<DocumentSnapshot> jsonList) {
    return jsonList.map((e) => ChatModel.fromJson(e)).toList();
  }
}