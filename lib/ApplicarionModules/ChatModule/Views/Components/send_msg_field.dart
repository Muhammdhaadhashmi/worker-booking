import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Utils/app_colors.dart';

// ignore: must_be_immutable
class SendMassageField extends StatelessWidget {
  SendMassageField({
    Key? key,
    this.hintText,
    this.controller,
    required this.onTap,
  }) : super(key: key);
  void Function() onTap;

  String? hintText;
  TextEditingController? controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
        height: 80,
        width: Get.width,
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.03),
              offset: const Offset(0, -1),
              blurRadius: 6,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: TextFormField(
                controller: controller,
                cursorColor: AppColors.mainColor,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                  suffixIcon: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // GestureDetector(
                      //
                      //   onTap: onTap,
                      //   child: Image.asset(
                      //     kSendButton,
                      //     height: 18,
                      //   ),
                      // ),
                      IconButton(onPressed: onTap, icon: Icon(Icons.send))
                    ],
                  ),
                  hintText: hintText,
                  filled: true,
                  fillColor: AppColors.white,
                  hintStyle: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(
                      color: AppColors.mainColor.withOpacity(0.4),
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(
                      color: AppColors.mainColor.withOpacity(0.4),
                      width: 1.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
