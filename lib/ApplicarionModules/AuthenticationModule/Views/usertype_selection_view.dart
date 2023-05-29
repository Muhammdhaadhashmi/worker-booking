import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:worker_booking/ApplicarionModules/AuthenticationModule/Views/sign_in_view.dart';

import '../../../Utils/dimensions.dart';
import 'Components/selection_tile.dart';

class UsertypeSelectionView extends StatefulWidget {
  const UsertypeSelectionView({Key? key}) : super(key: key);

  @override
  State<UsertypeSelectionView> createState() => _UsertypeSelectionViewState();
}

class _UsertypeSelectionViewState extends State<UsertypeSelectionView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: Dimensions.screenWidth(context),
        height: Dimensions.screenHeight(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SelectionTile(
                  txt: "Worker",
                  img: "assets/Images/engineer.png",
                  onTap: () {
                    Get.to(
                      SignInView(type: 1),
                      transition: Transition.rightToLeft,
                      duration: Duration(milliseconds: 600),
                    );
                  },
                ),
                SelectionTile(
                  txt: "Customer",
                  img: "assets/Images/man.png",
                  onTap: () {
                    Get.to(
                      SignInView(type: 0),
                      transition: Transition.rightToLeft,
                      duration: Duration(milliseconds: 600),
                    );
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
