import 'package:flutter/material.dart';

class CheckoutComponentModel {
  Widget? icon;
  String text;
  String? subText;
  String? trailingText;
  bool? grayTextStyle;
  bool? haveBackGround;
  bool? haveSwitch;

  CheckoutComponentModel({
    this.icon,
    required this.text,
    this.subText,
    this.trailingText,
    this.grayTextStyle,
    this.haveBackGround,
    this.haveSwitch,
  });
}
