import 'dart:ui';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:worker_booking/ApplicarionModules/ProfileModule/Models/user_model.dart';

import '../../../../Utils/app_colors.dart';
import '../../../../Utils/btn.dart';
import '../../../../Utils/dimensions.dart';
import '../../../../Utils/spaces.dart';
import '../../../../Utils/text_edit_field.dart';
import '../../../../Utils/text_view.dart';
import '../../../ChatModule/Services/chat_service.dart';
import '../../../ProfileModule/ViewModels/profile_view_model.dart';
import '../Models/booking_model.dart';
import 'booking_success_view.dart';

class BookingSummaryView extends StatefulWidget {
  final UserModel userModel;

  const BookingSummaryView({super.key, required this.userModel});

  @override
  State<BookingSummaryView> createState() => _BookingSummaryViewState();
}

class _BookingSummaryViewState extends State<BookingSummaryView> {
  String time = "";
  ProfileViewModel pVM = Get.put(ProfileViewModel());

  // int days = 0;
  bool loading = false;

  TextEditingController from = TextEditingController();
  TextEditingController to = TextEditingController();
  TextEditingController des = TextEditingController();
  TextEditingController add = TextEditingController();

  //List<DateTime?> dates = [1,2,3,4,5,6];
  //List<int?> dates = [1, 2, 3, 4, 5, 6];

  List<String> hours = ['1', '2', '3', '4','5']; // Option 2
  String? _selectedhour; //

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        from.text = DateFormat.yMMMMEEEEd().format(selectedDate);
        selectedDate = picked;
      });
    }
  }

  // showDialogView() {
  //   showAnimatedDialog(
  //     context: context,
  //     barrierDismissible: true,
  //     builder: (BuildContext context) {
  //       return Container(
  //         height: Dimensions.screenHeight(context),
  //         width: Dimensions.screenWidth(context),
  //         padding: EdgeInsets.symmetric(horizontal: 20),
  //         child: Center(
  //           child: Material(
  //             child: CalendarDatePicker2WithActionButtons(
  //               config: CalendarDatePicker2WithActionButtonsConfig(
  //                 calendarType: CalendarDatePicker2Type.range,
  //                 selectedDayHighlightColor: AppColors.mainColor,
  //               ),
  //               onCancelTapped: () {
  //                 Navigator.pop(context);
  //               },
  //               initialValue: dates.length != 0 ? dates : [],
  //               onValueChanged: (dates) {
  //                 if (dates.isNotEmpty) {
  //                   setState(() {
  //                     this.dates = dates;
  //                     from.text = DateFormat.yMMMMEEEEd().format(dates[0]!);
  //                     to.text = DateFormat.yMMMMEEEEd().format(dates[1]!);
  //                     days = dates[1]!.day - dates[0]!.day;
  //                   });
  //                   Navigator.pop(context);
  //                 }
  //               },
  //               // onOkTapped: (){
  //               // },
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //     animationType: DialogTransitionType.size,
  //     curve: Curves.fastOutSlowIn,
  //     duration: Duration(seconds: 1),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    double blur = loading ? 5 : 0;

    return Stack(
      children: [
        ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Scaffold(
            body: Container(
              height: Dimensions.screenHeight(context),
              width: Dimensions.screenWidth(context),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AddVerticalSpace(50),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 45,
                              width: 45,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.mainColor,
                              ),
                              child: Icon(
                                Icons.chevron_left,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                          // AddHorizontalSpace(10),
                          Container(
                            width: Dimensions.screenWidth(context) - 110,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextView(
                                  text: "SUMMARY",
                                  color: AppColors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    AddVerticalSpace(40),

                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      // height: 65,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextEditField(
                            hintText: "Choose Date",
                            readOnly: true,
                            textEditingController: from,
                            hintSize: 14,
                            cursorColor: AppColors.mainColor,
                            width: Dimensions.screenWidth(context),
                            onTap: () {
                              _selectDate(context);
                            },
                          ),

                          AddVerticalSpace(10),
                          TextView(
                            text: "Starting Time",
                            color: AppColors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          AddVerticalSpace(10),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: DateTimePicker(
                              type: DateTimePickerType.time,
                              cursorColor: AppColors.mainColor,
                              // timePickerEntryModeInput: true,
                              initialValue: "",
                              //_initialValue,
                              icon: Icon(Icons.access_time,color: AppColors.mainColor,size: 40,),
                              timeLabelText: "Time",style: TextStyle(color: AppColors.mainColor,fontSize:20,fontWeight: FontWeight.bold ),
                              use24HourFormat: true,
                              onChanged: (value) {
                                setState(() {
                                  // hours = int.parse(value.substring(0,1));
                                  // mins = int.parse(value.substring(3,4));
                                  time = value;
                                });
                                // print(hours);
                                // print(mins);
                              },
                            ),
                            // child: TextEditField(
                            //   hintText: "Time",
                            //   readOnly: true,
                            //   cursorColor: AppColors.mainColor,
                            //   textCapitalization: TextCapitalization.none,
                            //   preffixIcon: Icon(
                            //     Icons.timer,
                            //     color: AppColors.mainColor,
                            //   ),
                            //   textEditingController: time,
                            //   errorText: timevalidate ? "Time Requried" : null,
                            //   width: Dimensions.screenWidth(context),
                            //   onTap: () {
                            //     showDialogView();
                            //   },
                            // ),
                          ),


                          TextView(
                            text: "Select Number of Hours",
                            color: AppColors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          AddVerticalSpace(10),
                          Container(
                            height: 50,
                            width: Dimensions.screenWidth(context),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.mainColor,width: 1)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: DropdownButton(
                                hint: Text(
                                    'Select hours'), // Not necessary for Option 1
                                value: _selectedhour,
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedhour = newValue!;
                                  });
                                },
                                items: hours.map((location) {
                                  return DropdownMenuItem(
                                    child: new Text(location),
                                    value: location,
                                  );
                                }).toList(),
                              ),
                            ),
                          )
                          

                          // AddVerticalSpace(20),
                          // TextView(
                          //   text: "To",
                          //   fontSize: 15,
                          //   fontWeight: FontWeight.w500,
                          // ),
                          // TextEditField(
                          //   hintText: "To",
                          //   readOnly: true,
                          //   hintSize: 14,
                          //   cursorColor: AppColors.mainColor,
                          //   textEditingController: to,
                          //   width: Dimensions.screenWidth(context),
                          //   onTap: () {
                          //     showDialogView();
                          //   },
                          // ),
                        ],
                      ),
                    ),
                    AddVerticalSpace(40),
                    hours != 0
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: TextView(
                                  text: " Number of hours ${_selectedhour} ",
                                  color: AppColors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              AddVerticalSpace(30),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  children: [
                                    // Container(
                                    //   height: 173,
                                    //   width: 89,
                                    //   decoration: BoxDecoration(
                                    //     color: AppColors.mainColor
                                    //         .withOpacity(0.3),
                                    //     borderRadius: BorderRadius.circular(50),
                                    //   ),
                                    //   child: Column(
                                    //     mainAxisAlignment:
                                    //         MainAxisAlignment.spaceAround,
                                    //     children: [
                                    //       // Container(
                                    //       //   width: 63,
                                    //       //   height: 63,
                                    //       //   decoration: BoxDecoration(
                                    //       //     color: AppColors.white,
                                    //       //     shape: BoxShape.circle,
                                    //       //   ),
                                    //       //   child: Column(
                                    //       //     mainAxisAlignment:
                                    //       //         MainAxisAlignment.spaceEvenly,
                                    //       //     children: [
                                    //       //       TextView(
                                    //       //         text:
                                    //       //             "${DateFormat.MMM().format(dates[0]!)}",
                                    //       //       ),
                                    //       //       TextView(
                                    //       //         text:
                                    //       //             "${DateFormat.d().format(dates[0]!)}",
                                    //       //         fontSize: 16,
                                    //       //         fontWeight: FontWeight.w700,
                                    //       //       ),
                                    //       //     ],
                                    //       //   ),
                                    //       // ),
                                    //       // Container(
                                    //       //   width: 63,
                                    //       //   height: 63,
                                    //       //   decoration: BoxDecoration(
                                    //       //     color: AppColors.white,
                                    //       //     shape: BoxShape.circle,
                                    //       //   ),
                                    //       //   child: Column(
                                    //       //     mainAxisAlignment:
                                    //       //         MainAxisAlignment.spaceEvenly,
                                    //       //     children: [
                                    //       //       TextView(
                                    //       //         text:
                                    //       //             "${DateFormat.MMM().format(dates[1]!)}",
                                    //       //       ),
                                    //       //       TextView(
                                    //       //         text:
                                    //       //             "${DateFormat.d().format(dates[1]!)}",
                                    //       //         fontSize: 16,
                                    //       //         fontWeight: FontWeight.w700,
                                    //       //       ),
                                    //       //     ],
                                    //       //   ),
                                    //       // ),
                                    //     ],
                                    //   ),
                                    // ),
                                    // AddHorizontalSpace(20),
                                    // Container(
                                    //   height: 173,
                                    //   child: Column(
                                    //     crossAxisAlignment:
                                    //         CrossAxisAlignment.start,
                                    //     mainAxisAlignment:
                                    //         MainAxisAlignment.spaceAround,
                                    //     children: [
                                    //       TextView(
                                    //         text: "Staring",
                                    //         fontSize: 16,
                                    //         fontWeight: FontWeight.w700,
                                    //       ),
                                    //       TextView(
                                    //         text: "Finishing",
                                    //         fontSize: 16,
                                    //         fontWeight: FontWeight.w700,
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                              AddVerticalSpace(16),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: TextView(
                                  text: "Fee & Tax Details",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              AddVerticalSpace(16),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextView(


                                          text:
                                         _selectedhour!=null ? "${widget.userModel.price} x ${_selectedhour} Hours":"0",
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        TextView(
                                          text:
                                          _selectedhour!=null ?  "${widget.userModel.price * int.parse(_selectedhour!)}":"0",
                                             // "${widget.userModel.price * _selectedhour.toString()}",
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ],
                                    ),
                                    AddVerticalSpace(16),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextView(
                                          text: "Service charges",
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        TextView(
                                          text: "25",
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ],
                                    ),
                                    AddVerticalSpace(22),
                                    Divider(
                                      height: 1,
                                      color: AppColors.grey,
                                    ),
                                    AddVerticalSpace(17),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextView(
                                          text: "Total",
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        TextView(
                                          text:
                                          _selectedhour!=null ?"${(widget.userModel.price * int.parse(_selectedhour!)) + 25}":"0",
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ],
                                    ),
                                    AddVerticalSpace(25),
                                    // Container(
                                    //   width: Dimensions.screenWidth(context),
                                    //   height: 60,
                                    //   decoration: BoxDecoration(
                                    //       color: AppColors.grey.withOpacity(0.2),
                                    //       borderRadius: BorderRadius.circular(50)),
                                    //   child: Row(
                                    //     mainAxisAlignment: MainAxisAlignment.center,
                                    //     children: [
                                    //       // Icon(Icons.credit_card,color: AppColors.mainColor,),
                                    //       Container(
                                    //         width: 45,
                                    //         child: Stack(
                                    //           children: [
                                    //             Positioned(
                                    //               child: Container(
                                    //                 height: 24,
                                    //                 width: 24,
                                    //                 decoration: BoxDecoration(
                                    //                   color: Colors.red.withOpacity(0.8),
                                    //                   shape: BoxShape.circle,
                                    //                 ),
                                    //               ),
                                    //             ),
                                    //             Positioned(
                                    //               left: 15,
                                    //               child: Container(
                                    //                 height: 24,
                                    //                 width: 24,
                                    //                 decoration: BoxDecoration(
                                    //                   color: Colors.orange.withOpacity(0.8),
                                    //                   shape: BoxShape.circle,
                                    //                 ),
                                    //               ),
                                    //             )
                                    //           ],
                                    //         ),
                                    //       ),
                                    //       TextView(
                                    //         text: "Pay with Master Card",
                                    //         fontSize: 16,
                                    //         color: AppColors.black,
                                    //         fontWeight: FontWeight.w700,
                                    //       ),
                                    //     ],
                                    //   ),
                                    // )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                child: TextEditField(
                                  hintText: "Description",
                                  hintSize: 14,
                                  cursorColor: AppColors.mainColor,
                                  textEditingController: des,
                                  width: Dimensions.screenWidth(context),

                                ),
                              ),
                            ],
                          )
                        : SizedBox(),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(10.0),
              child: BTN(
                title: "Book Now",
                color: AppColors.mainColor,
                textColor: AppColors.white,
                width: Dimensions.screenWidth(context),
                onPressed: () async {
                  if (hours != 0) {
                    setState(() {
                      loading = true;
                    });
                    int time = DateTime.now().microsecondsSinceEpoch;

                    BookingModel bookingModel = BookingModel(
                      customerAdress: pVM.userList.value[0].address,
                      paid:0,
                      customerName: pVM.userList.value[0].name,
                      days: int.parse(_selectedhour!),
                      price: widget.userModel.price,
                      workerName: widget.userModel.name,
                      address: widget.userModel.address,
                      time: time,
                      customerEmail: pVM.userList.value[0].email,
                      // from: dates[0]!.microsecondsSinceEpoch,
                      // to: dates[1]!.microsecondsSinceEpoch,
                      from: DateFormat.yMMMMEEEEd().format(selectedDate),
                      to: DateFormat.yMMMMEEEEd().format(selectedDate),
                      customerPhoneNumber: pVM.userList.value[0].phoneNumber,
                      description: des.text,
                      bookingStatus: "Booked",
                      workerEmail: widget.userModel.email,
                      coordinates: pVM.userList.value[0].coordinates,
                    );

                    await FirebaseFirestore.instance
                        .collection("bookings")
                        .doc("${time}")
                        .set(
                          bookingModel.toJson(),
                        );
                    await FirebaseFirestore.instance
                        .collection("users")
                        .doc("${widget.userModel.email}")
                        .update({
                      "ocupied": 1,
                    });
                    sendAndRetrieveMessage(
                        msg:
                            "You have new Booking fom ${FirebaseAuth.instance.currentUser!.email!}",
                        tokin: pVM.userList.value[0].FCMToken,
                        username: pVM.userList.value[0].name);

                    Get.to(
                      BookingSuccessView(),
                      transition: Transition.rightToLeft,
                      duration: Duration(milliseconds: 600),
                    );
                  }
                },
              ),
            ),
          ),
        ),
        loading
            ? Container(
                height: Dimensions.screenHeight(context),
                width: Dimensions.screenWidth(context),
                color: AppColors.transparent,
                child: Center(
                  child: SpinKitThreeBounce(
                    color: AppColors.mainColor,
                    size: MediaQuery.of(context).size.width / 8,
                  ),
                ),
              )
            : SizedBox(),
      ],
    );
  }
}
