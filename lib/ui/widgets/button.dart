import 'package:flutter/material.dart';
import 'package:flutter_to_do_app/ui/helpers/colors.dart';
import 'package:get/get.dart';

class MyButton extends StatelessWidget {
  final String label;
  final Function()? onTap;

  const MyButton({Key? key, required this.label, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Get.isDarkMode ? CustomColors.white : CustomColors.primaryClr,
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              label,
              style: TextStyle(
                color: Get.isDarkMode
                    ? CustomColors.primaryClr
                    : CustomColors.white,
                fontFamily: 'Lato',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
