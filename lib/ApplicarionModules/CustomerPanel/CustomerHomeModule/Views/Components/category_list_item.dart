import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../Utils/app_colors.dart';
import '../../../../../Utils/dimensions.dart';
import '../../../../../Utils/text_view.dart';
import '../../../WorkerModule/Views/workers_list_view.dart';

class CategoryListItem extends StatefulWidget {
  final itemData;

  const CategoryListItem({Key? key, required this.itemData}) : super(key: key);

  @override
  State<CategoryListItem> createState() => _CategoryListItemState();
}

class _CategoryListItemState extends State<CategoryListItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(
          WorkersListView(),
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
            borderRadius: BorderRadius.circular(20), color: AppColors.cat_back),
        child: Column(
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  widget.itemData["cat_img"],
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              width: Dimensions.screenWidth(context),
              // height: double.infinity,
              child: Center(
                child: TextView(
                  text: widget.itemData["cat_name"],
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
