import 'package:flutter/material.dart';
import 'package:worker_booking/ApplicarionModules/CustomerPanel/WorkerModule/Views/Components/worker_home_conatiner.dart';

class WorkerBookingView extends StatefulWidget {
  const WorkerBookingView({Key? key}) : super(key: key);

  @override
  State<WorkerBookingView> createState() => _WorkerBookingViewState();
}

class _WorkerBookingViewState extends State<WorkerBookingView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              WorkerHomeContainer(
                imgheight:66,
                imgwidth: 83,
                boxcolor: const Color(0xffEFC9FC),
                boxtext: "Live Navigation",
                callback: () async {

                },
              ),
              const SizedBox(
                width: 10,
              ),
              WorkerHomeContainer(
                imgheight: 66,
                imgwidth: 96,
                boxtext: 'Voice Navigation',
                boxcolor: const Color(0xffEEE1FF),
                callback: () {


                },
              )
            ],
          ),
        ],

      ),
    );
  }
}
