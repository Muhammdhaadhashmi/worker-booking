import 'package:flutter/material.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import '../../../../../Utils/app_colors.dart';
import '../../../../../Utils/dimensions.dart';
import '../../../../../Utils/spaces.dart';
import '../../../../../Utils/text_view.dart';
import '../../../../ProfileModule/Models/user_model.dart';

class WokerListItem extends StatefulWidget {
  final UserModel userModel;

  const WokerListItem({Key? key, required this.userModel})
      : super(key: key);

  @override
  State<WokerListItem> createState() => _WokerListItemState();
}

class _WokerListItemState extends State<WokerListItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
      },
      child: Container(
        width: 150,
        height: 250,
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.cat_back,
            boxShadow: [BoxShadow(color: AppColors.grey, blurRadius: 3)]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
            TextView(
              text: widget.userModel.name,
              fontSize: 22,
              color: AppColors.black,
            ),
          ],
        ),
      ),
    );
  }
}
