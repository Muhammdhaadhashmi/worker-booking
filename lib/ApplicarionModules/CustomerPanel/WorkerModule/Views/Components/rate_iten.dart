import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:worker_booking/ApplicarionModules/CustomerPanel/WorkerModule/Views/worker_detail_view.dart';
import 'package:geocoding/geocoding.dart' as geo;
import '../../../../../Utils/app_colors.dart';
import '../../../../../Utils/dimensions.dart';
import '../../../../../Utils/spaces.dart';
import '../../../../../Utils/text_view.dart';
import '../../../../ProfileModule/Models/user_model.dart';
import '../../../CustomerBookingModule/Models/rate_model.dart';

class RateListItem extends StatefulWidget {
  final RateModel userModel;

  const RateListItem({Key? key, required this.userModel}) : super(key: key);

  @override
  State<RateListItem> createState() => _RateListItemState();
}



class _RateListItemState extends State<RateListItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: Dimensions.screenWidth(context),
        height: 150,
        margin: EdgeInsets.only(bottom: 20, left: 10, right: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: AppColors.cat_back),
        child: Row(
          children: [
            AddHorizontalSpace(20),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextView(
                  text: "Cutsomer Name: ${widget.userModel.customerName}",
                  fontSize: 18,
                ),
                Container(
                  width: 200,
                  child: TextView(
                    text: "Comment : " + widget.userModel.comment,
                    fontSize: 16,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                ),
                TextView(
                  text: "Ratings : " + widget.userModel.rate,
                  fontSize: 16,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
