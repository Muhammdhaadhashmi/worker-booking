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

class WorkerHomeListItem extends StatefulWidget {
  final UserModel userModel;

  const WorkerHomeListItem({Key? key, required this.userModel})
      : super(key: key);

  @override
  State<WorkerHomeListItem> createState() => _WorkerHomeListItemState();
}

class _WorkerHomeListItemState extends State<WorkerHomeListItem> {
  String address = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAddressFromLocation();
  }

  getAddressFromLocation() async {
    List<geo.Placemark> sourcePlacemark = await geo.placemarkFromCoordinates(
        widget.userModel.coordinates[0], widget.userModel.coordinates[1]);
    geo.Placemark sourcePlace = sourcePlacemark[0];
    setState(() {
      address =
          "${sourcePlace.locality} ${sourcePlace.administrativeArea} ${sourcePlace.country}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(
          WorkerDetailsView(
            forBooking: true,
            userModel: widget.userModel,
          ),
          transition: Transition.rightToLeft,
          duration: Duration(milliseconds: 600),
        );
      },
      child: Container(
        width: Dimensions.screenWidth(context),
        height: 150,
        margin: EdgeInsets.only(bottom: 20, left: 10, right: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: AppColors.cat_back),
        child: Row(
          children: [
            Container(
              height: 60,
              width: 60,
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.white,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: OptimizedCacheImage(
                  imageUrl: widget.userModel.userImage,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Center(
                    child: CircularProgressIndicator(
                      value: downloadProgress.progress,
                      color: AppColors.mainColor,
                    ),
                  ),
                  errorWidget: (context, url, error) => Icon(
                    Icons.error,
                    color: AppColors.mainColor,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            AddHorizontalSpace(20),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextView(
                  text: widget.userModel.name,
                  fontSize: 18,
                ),
                Container(
                  width: 200,
                  child: TextView(
                    text: "Address : " + address,
                    fontSize: 16,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                ),
                TextView(
                  text: "Experience : " + widget.userModel.experience,
                  fontSize: 16,
                ),
                TextView(
                  text: "Skill : " + widget.userModel.skills,
                  fontSize: 16,
                ),
                // RatingBar.builder(
                //   initialRating:4.5,
                //   minRating: 0,
                //   direction: Axis.horizontal,
                //   allowHalfRating: true,
                //   itemCount: 5,
                //   ignoreGestures: true,
                //   itemSize: 25,
                //   glowColor: AppColors.back,
                //   itemBuilder: (context, _) => Icon(
                //     Icons.star,
                //     color: Colors.amber,
                //   ),
                //   onRatingUpdate: (rating) {
                //   },
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
