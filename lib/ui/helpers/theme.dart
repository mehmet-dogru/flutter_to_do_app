import 'package:flutter/material.dart';
import 'package:flutter_to_do_app/ui/helpers/colors.dart';

class Themes {
  static final light = ThemeData(
    backgroundColor: CustomColors.white,
    primaryColor: CustomColors.primaryClr,
    brightness: Brightness.light,
  );

  static final dark = ThemeData(
    backgroundColor: CustomColors.darkGreyClr,
    primaryColor: CustomColors.darkGreyClr,
    brightness: Brightness.dark,
  );
}
