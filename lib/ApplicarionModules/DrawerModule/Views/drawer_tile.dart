import 'package:flutter/material.dart';

import '../../../Utils/app_colors.dart';
import '../../../Utils/text_view.dart';

class DrawerTile extends StatelessWidget {
  final VoidCallback onTap;
  final bool issetting;
  final bool isIcon;
  final String? img;
  final IconData icon;
  final String title;

  const DrawerTile({
    Key? key,
    required this.onTap,
    this.issetting = true,
    this.isIcon = true,
    this.img,
    required this.icon,
    required this.title,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        // color: Colors.green,
        // height: 33,
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                !issetting
                    ? SizedBox(
                  width: 40,
                )
                    : SizedBox(
                  width: 20,
                ),
                !isIcon
                    ? Image(
                  image: AssetImage(img!),
                  height: 20,
                  color: AppColors.mainColor,
                )
                    : Icon(
                  icon,
                  color: AppColors.mainColor,
                ),
                SizedBox(
                  width: 20,
                ),
                TextView(
                  text: title,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),

              ],
            ),

          ],
        ),
      ),
    );
  }
}