import 'package:flutter/material.dart';
import '../../../../../Utils/app_colors.dart';
import '../../../../../Utils/dimensions.dart';
import '../../../../../Utils/text_view.dart';

class WorkerOrder extends StatelessWidget {
  final String title;
  final int num;

  const WorkerOrder({Key? key, required this.title, required this.num})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextView(
          text: title,
          fontSize: 16,
        ),
        SizedBox(
          width: Dimensions.screenWidth(context)/2.5,
            child: Divider(
          height: 1,
              color: AppColors.mainColor,
        )),
        TextView(
          text: '$num',
          fontSize: 16,
        ),
      ],
    );
  }
}
