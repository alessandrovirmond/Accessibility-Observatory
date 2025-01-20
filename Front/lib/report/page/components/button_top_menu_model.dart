import 'package:flutter/material.dart';

class ButtonTopMenuModel {
  final String title;
  final Function() onTap;
  final IconData icon;

  ButtonTopMenuModel(
      {required this.title, required this.onTap, required this.icon});
}
