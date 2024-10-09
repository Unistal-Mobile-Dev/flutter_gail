import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DrawerModel {
  Widget widget;
  String label;
  IconData icon;
  List<DrawerSubModel> sublist;
  bool isSelected;
  Widget? actionButtonWidget;
  bool? isSublistLoader = false;

  DrawerModel(
      {required this.widget,
      required this.icon,
      required this.label,
      required this.sublist,
      required this.isSelected,
      this.isSublistLoader,
      this.actionButtonWidget});
}

class DrawerSubModel {
  String? label;
  bool? isSelected;
  Widget? widget;
  Widget? actionButtonWidget;

  DrawerSubModel(
      {this.label, this.isSelected, this.widget, this.actionButtonWidget});
}
