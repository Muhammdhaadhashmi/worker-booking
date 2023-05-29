import 'package:flutter/material.dart';

import '../../../../../Utils/app_colors.dart';

class ContactBTN extends StatefulWidget {
  final IconData icon;
  final onTap;

  const ContactBTN({super.key, required this.icon, required this.onTap});

  @override
  State<ContactBTN> createState() => _ContactBTNState();
}

class _ContactBTNState extends State<ContactBTN> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        height: 32,
        width: 32,
        // padding: EdgeInsets.all(5),
        decoration:
        BoxDecoration(shape: BoxShape.circle, color: AppColors.mainColor),
        child: Icon(
          widget.icon,
          color: AppColors.white,
          size: 20,
        ),
      ),
    );
  }
}
