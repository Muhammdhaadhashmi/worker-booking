import 'package:flutter/material.dart';


class WorkerHomeContainer extends StatelessWidget {
  String? url;
  double imgwidth;
  double imgheight;
  Color boxcolor;
  String boxtext;
  VoidCallback callback;

  WorkerHomeContainer(
      {Key? key,
      required this.callback,
       this.url,
      required this.imgheight,
      required this.imgwidth,
      required this.boxcolor,
      required this.boxtext})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Container(
        height: MediaQuery.of(context).size.height/5.2,
        width: MediaQuery.of(context).size.width / 2.5,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow:  [
            BoxShadow(
            //  color: Color(0xffF2F2F2),
              color: Colors.blueGrey.shade200,
              blurRadius: 6,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Image(
                image: AssetImage("assets/Images/VBA.png"),
                width: imgwidth,
                height: imgheight,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: Container(
                margin: const EdgeInsets.only(left: 16, right: 16),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height/33,
                //height: 30,
                decoration: BoxDecoration(
                    color: boxcolor, borderRadius: BorderRadius.circular(8)),
                child: Center(child: Text(boxtext)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
