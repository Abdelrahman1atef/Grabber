import 'package:flutter/material.dart';

class PaymentMethodModel {
  final int id;
  final Widget icon;
  final String text;

  PaymentMethodModel({
    required this.id,
    required this.icon,
    required this.text,
  });
}
