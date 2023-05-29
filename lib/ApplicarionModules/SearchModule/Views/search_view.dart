import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:worker_booking/Utils/app_colors.dart';
import 'package:worker_booking/Utils/dimensions.dart';
import 'package:worker_booking/Utils/search_text_field.dart';
import 'package:worker_booking/Utils/spaces.dart';

import '../../../Utils/text_view.dart';
import '../../CustomerPanel/WorkerModule/ViewModels/woker_view_model.dart';
import '../../CustomerPanel/WorkerModule/Views/Components/worker_home_list_item.dart';
import '../../DrawerModule/Views/drawer_view.dart';
import '../../ProfileModule/Models/user_model.dart';
import '../../ProfileModule/ViewModels/profile_view_model.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> with TickerProviderStateMixin {
  TextEditingController search = TextEditingController();
  WorkerViewModel workerViewModel = Get.put(WorkerViewModel());


  ProfileViewModel profileViewModel = Get.put(ProfileViewModel());

  TabController? controller;
  List<Widget> categories = [
    Tab(child: TextView(text: "All")),
    Tab(child: TextView(text: "Carpenter")),
    Tab(child: TextView(text: "Constructor")),
    Tab(child: TextView(text: "Electricion")),
    Tab(child: TextView(text: "Mechanic")),
    Tab(child: TextView(text: "Painter")),
    Tab(child: TextView(text: "Plumber")),
    Tab(child: TextView(text: "Welder")),
  ];
  List catList = [
    "All",
    "Carpenter",
    "Constructor",
    "Electricion",
    "Mechanic",
    "Painter",
    "Plumber",
    "Welder",
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = TabController(length: 8, vsync: this);
    profileViewModel.getCurrentUser();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: AppColors.mainColor,
        title: SearchTextField(
            hintText: "Search",
            textEditingController: search,
            onChanged: (value) {
              workerViewModel.searchRes.value = value;
              workerViewModel.getWorkers();
            },
            width: Dimensions.screenWidth(context)),
      ),
      drawer: DrawerView(),
      body: Container(
        width: Dimensions.screenWidth(context),
        height: Dimensions.screenHeight(context),
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              Container(
                height: 50,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: TabBar(
                  isScrollable: true,
                  // physics: BouncingScrollPhysics(),
                  indicatorColor: AppColors.black,
                  controller: controller,
                  unselectedLabelColor: AppColors.black,
                  unselectedLabelStyle: TextStyle(color: AppColors.black),
                  indicator: BoxDecoration(
                    color: AppColors.mainColor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  tabs: categories,
                  onTap: (value) {
                    if (catList[value] != "All") {
                      workerViewModel.searchRes.value = catList[value];
                      workerViewModel.getWorkers();
                    } else {
                      workerViewModel.searchRes.value = '';
                      workerViewModel.getWorkers();
                    }
                  },
                ),
              ),
              AddVerticalSpace(20),
              Container(
                width: Dimensions.screenWidth(context),
                height: Dimensions.screenHeight(context) - 180,
                // color: AppColors.red,
                child: FutureBuilder(
                    future: workerViewModel.getWorkers(),
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
                            itemCount: workerViewModel.workerList.value.length,
                            itemBuilder: (context, index) {
                              var data = workerViewModel.workerList.value[index];
                              return WorkerHomeListItem(
                                userModel: UserModel(
                                  name: data.name,
                                  Category: data.Category,
                                  email: data.email,
                                  price: data.price,
                                  type: data.type,
                                  coordinates: data.coordinates,
                                  address: data.address,
                                  city: data.city,
                                  skills: data.skills,
                                  phoneNumber: data.phoneNumber,
                                  FCMToken: data.FCMToken,
                                  ocupied: data.ocupied,
                                  experience: data.experience,
                                  allOrders: data.allOrders,
                                  completedOrders: data.completedOrders,
                                  userImage: data.userImage,
                                ),
                              );
                            },
                          ));
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
