import 'package:flutter/material.dart';

import '../../gen/colors.gen.dart';
import '../../gen/fonts.gen.dart';

class TextStyles {
  static TextStyle get normalTextStyle => TextStyle(
    fontFamily: FontFamily.inter,
    fontSize: 15,
    fontWeight: FontWeight.bold
  );
  static TextStyle get categoryTextStyle => TextStyle(
    fontFamily: FontFamily.inter,
    fontSize: 15,
    fontWeight: FontWeight.bold,
    color: ColorName.grayTextColor
  );
}