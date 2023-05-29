import 'package:flutter/material.dart';
import 'package:worker_booking/Utils/spaces.dart';

import '../../../../Utils/app_colors.dart';
import '../../../../Utils/dimensions.dart';
import '../../../../Utils/text_view.dart';

class SelectionTile extends StatefulWidget {
  final String txt;
  final String img;
  final onTap;

  const SelectionTile({
    Key? key,
    required this.txt,
    required this.img,
    required this.onTap,
  }) : super(key: key);

  @override
  State<SelectionTile> createState() => _SelectionTileState();
}

class _SelectionTileState extends State<SelectionTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: Dimensions.screenWidth(context) / 2.5,
        height: 150,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: AppColors.grey, blurRadius: 3),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 100,
              width: 100,
              child: ClipRRect(
                child: Image.asset(widget.img),
              ),
            ),
            AddVerticalSpace(8),
            TextView(
              text: widget.txt,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            )
          ],
        ),
      ),
    );
  }
}
