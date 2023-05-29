import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:worker_booking/ApplicarionModules/CustomerPanel/CustomerBookingModule/Models/rate_model.dart';
import 'package:worker_booking/Utils/text_view.dart';

import '../../../../Utils/app_colors.dart';
import '../../../../Utils/dimensions.dart';
import '../../../ProfileModule/ViewModels/profile_view_model.dart';
import '../ViewModels/woker_view_model.dart';
import 'Components/rate_iten.dart';

class RatingsView extends StatefulWidget {
  final email;
  const RatingsView({Key? key, required this.email}) : super(key: key);

  @override
  State<RatingsView> createState() => _SearchViewState();
}

class _SearchViewState extends State<RatingsView>
    with TickerProviderStateMixin {
  WorkerViewModel workerViewModel = Get.put(WorkerViewModel());

  ProfileViewModel profileViewModel = Get.put(ProfileViewModel());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    profileViewModel.getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        title: Text("Rating View"),
      ),
      body: Container(
        width: Dimensions.screenWidth(context),
        height: Dimensions.screenHeight(context),
        padding: EdgeInsets.all(10),
        child: FutureBuilder(
            future: workerViewModel.getRatings(widget.email),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: SpinKitThreeBounce(
                    color: AppColors.mainColor,
                    size: MediaQuery.of(context).size.width / 8,
                  ),
                );
              }
              return Obx(() => ListView.builder(
                itemCount: workerViewModel.rateList.value.length,
                itemBuilder: (context, index) {
                  var data = workerViewModel.rateList.value[index];
                  return RateListItem(
                    userModel: RateModel(
                        customerName: data.customerName,
                        workerName: data.workerName,
                        time: data.time,
                        customerEmail: data.customerEmail,
                        workerEmail: data.workerEmail,
                        rate: data.rate,
                        comment: data.comment,
                        isreview: data.isreview),
                  );
                },
              ));
            }),
      ),
    );
  }
}
