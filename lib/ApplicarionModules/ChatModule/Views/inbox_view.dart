import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Utils/app_colors.dart';
import '../../../Utils/dimensions.dart';
import '../../../Utils/no_record.dart';
import '../../../Utils/search_text_field.dart';
import '../../../Utils/spaces.dart';
import '../../../Utils/text_view.dart';
import '../../ProfileModule/Models/user_model.dart';
import '../ViewModels/chat_view_model.dart';
import 'Components/inbox_list_item.dart';

class InboxView extends StatefulWidget {
  const InboxView({Key? key}) : super(key: key);

  @override
  State<InboxView> createState() => _InboxViewState();
}

class _InboxViewState extends State<InboxView> {
  TextEditingController search = TextEditingController();

  ChatViewModel cVM = Get.put(ChatViewModel());

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    cVM.searchRes.value = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        title: TextView(text: "Inbox"),
      ),
      body: Container(
        height: Dimensions.screenHeight(context),
        width: Dimensions.screenWidth(context),
        // padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // AddVerticalSpace(50),
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 20),
              //   child: SearchTextField(
              //     width: Dimensions.screenWidth(context),
              //     hintText: "Search",
              //     textEditingController: search,
              //     prefixIcon: Icon(Icons.search),
              //     onChanged: (value){
              //       cVM.searchRes.value = value;
              //       cVM.getInbox();
              //     },
              //   ),
              // ),
              FutureBuilder(
                  future: cVM.getInbox(),
                  builder: (context, snapshot) {
                    return Obx(() => cVM.inboxList.value.length != 0
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: cVM.inboxList.value.length,
                            itemBuilder: (context, index) {
                              var data = cVM.inboxList.value[index];
                              return InboxListItem(
                                index: index,
                                userModel: UserModel(
                                  name: data.name,
                                  Category: data.Category,
                                  price: data.price,
                                  email: data.email,
                                  type: data.type,
                                  coordinates: data.coordinates,
                                  address: data.address,
                                  city: data.city,
                                  ocupied: data.ocupied,
                                  skills: data.skills,
                                  phoneNumber: data.phoneNumber,
                                  FCMToken: data.FCMToken,
                                  experience: data.experience,
                                  allOrders: data.allOrders,
                                  completedOrders: data.completedOrders,
                                  userImage: data.userImage,
                                ),
                              );
                            },
                          )
                        : NoRecord());
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
