import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import '../../../Utils/app_colors.dart';
import '../../../Utils/dimensions.dart';
import '../../../Utils/no_record.dart';
import '../../../Utils/spaces.dart';
import '../../../Utils/text_view.dart';
import '../../ProfileModule/Models/user_model.dart';
import '../../ProfileModule/ViewModels/profile_view_model.dart';
import '../Models/chat_model.dart';
import '../Services/chat_service.dart';
import '../ViewModels/chat_view_model.dart';
import 'Components/chat_list_item.dart';
import 'Components/send_msg_field.dart';

class ChatView extends StatefulWidget {
  final UserModel userModel;

  const ChatView({super.key, required this.userModel});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  TextEditingController message = TextEditingController();
  ProfileViewModel pVM = Get.put(ProfileViewModel());
  ChatViewModel cVM = Get.put(ChatViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            InkWell(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20)),
              onTap: () {
                Navigator.pop(context);
              },
              child: Row(
                children: [
                  Icon(
                    Icons.chevron_left,
                    color: AppColors.mainColor,
                    size: 28,
                  ),
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        color: AppColors.mainColor, shape: BoxShape.circle),
                    child: ClipOval(
                      // borderRadius: BorderRadius.circular(100),
                      child: OptimizedCacheImage(
                        imageUrl: widget.userModel.userImage,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) => Container(
                          height: 30,
                          width: 30,
                          child: Center(
                            child: CircularProgressIndicator(
                              value: downloadProgress.progress,
                              color: AppColors.white,
                              strokeWidth: 3,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Icon(
                          Icons.error,
                          color: AppColors.white,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            AddHorizontalSpace(10),
            TextView(
              text: widget.userModel.name,
              color: AppColors.black,
            ),
          ],
        ),
        elevation: 0,
        backgroundColor: AppColors.white,
      ),
      body: Stack(
        children: [
          Container(
            height: Dimensions.screenHeight(context),
            width: Dimensions.screenWidth(context),
            padding: EdgeInsets.only(bottom: 80),
            child: FutureBuilder(
                future: cVM.getChat(email: widget.userModel.email),
                builder: (context, snapshot) {
                  return Obx(() =>  cVM.chatList.value.length!=0?ListView.builder(
                    itemCount: cVM.chatList.value.length,
                    reverse: true,
                    itemBuilder: (context, index) {
                      var data = cVM.chatList.value[index];
                      return ChatListItem(
                        index: index,
                        chatModel: ChatModel(
                          time: data.time,
                          message: data.message,
                          isme: data.isme,
                        ),
                      );
                    },
                  ):NoRecord());
                }),
          ),
          SendMassageField(
            controller: message,
            hintText: "Message",
            onTap: () async {
              var data = pVM.userList.value[0];
              UserModel currentUser = UserModel(
                name: data.name,
                Category: data.Category,
                price: data.price,
                email: data.email,
                type: data.type,
                coordinates:data.coordinates,
                address: data.address,
                city: data.city,
                skills: data.skills,
                phoneNumber: data.phoneNumber,
                FCMToken: data.FCMToken,
                experience: data.experience,
                allOrders: data.allOrders,
                completedOrders: data.completedOrders,
                userImage: data.userImage,
                ocupied: data.ocupied,
              );

              cVM.getChat(email: widget.userModel.email);


              if (message.text.isNotEmpty) {
                String mesage = message.text.toString();
                int time = DateTime.now().microsecondsSinceEpoch;
                setState(() {
                  message.text = "";
                });
                await FirebaseFirestore.instance
                    .collection("users")
                    .doc(currentUser.email)
                    .collection("inbox")
                    .doc(widget.userModel.email)
                    .set(
                      widget.userModel.toJson(),
                    );


                await FirebaseFirestore.instance.collection("users")
                  .doc("${widget.userModel.email}").update({"allOrders":pVM.userList.value[0].allOrders});

                await FirebaseFirestore.instance
                    .collection("users")
                    .doc(currentUser.email)
                    .collection("inbox")
                    .doc("${widget.userModel.email}")
                    .collection("messages")
                    .doc("${time}")
                    .set({
                  "message": mesage,
                  "time": time,
                  "isMe": true,
                });

                /////////////////////////////
                /////////////////////////////
                await FirebaseFirestore.instance
                    .collection("users")
                    .doc("${widget.userModel.email}")
                    .collection("inbox")
                    .doc(currentUser.email)
                    .set(
                      currentUser.toJson(),
                    );

                await FirebaseFirestore.instance
                    .collection("users")
                    .doc("${widget.userModel.email}")
                    .collection("inbox")
                    .doc(currentUser.email)
                    .collection("messages")
                    .doc("${time}")
                    .set({"message": mesage, "time": time, "isMe": false});
                print(widget.userModel.FCMToken);

                sendAndRetrieveMessage(
                    msg: mesage,
                    tokin: widget.userModel.FCMToken,
                    username: currentUser.email);
              }
            },
          ),
        ],
      ),
    );
  }
}
