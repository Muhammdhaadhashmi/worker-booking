import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';

import '../../../../Utils/app_colors.dart';
import '../../../../Utils/dimensions.dart';
import '../../../../Utils/spaces.dart';
import '../../../../Utils/text_view.dart';
import '../../../ProfileModule/Models/user_model.dart';
import '../../ViewModels/chat_view_model.dart';
import '../chat_view.dart';

class InboxListItem extends StatefulWidget {
  final int index;
  final UserModel userModel;

  const InboxListItem(
      {super.key, required this.index, required this.userModel});

  @override
  State<InboxListItem> createState() => _InboxListItemState();
}

class _InboxListItemState extends State<InboxListItem> {

  ChatViewModel cVM = Get.put(ChatViewModel());

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Dimensions.screenWidth(context),
      child: InkWell(
        onTap: () {
          Get.to(
            ChatView(userModel: widget.userModel),
            transition: Transition.rightToLeft,
            duration: Duration(milliseconds: 600),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.mainColor,
                        ),
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
                      Positioned(
                        top: 0,
                        right: 1,
                        child: Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                            color: AppColors.green,
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                      ),
                    ],
                  ),
                  AddHorizontalSpace(15),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextView(
                        text: widget.userModel.name,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                      AddVerticalSpace(5),
                      TextView(
                        text: widget.userModel.email,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ],
                  )
                ],
              ),
              // Column(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   crossAxisAlignment: CrossAxisAlignment.end,
              //   children: [
              //     // AddVerticalSpace(5),
              //     TextView(
              //       text: "3:30 PM",
              //       fontSize: 12,
              //       fontWeight: FontWeight.w400,
              //       color: AppColors.grey,
              //     ),
              //     AddVerticalSpace(5),
              //     Container(
              //       height: 18,
              //       width: 18,
              //       decoration: BoxDecoration(
              //           color: AppColors.red, shape: BoxShape.circle),
              //       child: Center(
              //         child: TextView(
              //           text: "3",
              //           color: AppColors.white,
              //         ),
              //       ),
              //     )
              //   ],
              // )
            ],
          ),
        ),
      ),
    );
  }
}
