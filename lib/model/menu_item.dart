import 'package:boimteric_app_getx/model/tab_item.dart';
import 'package:flutter/material.dart';

class MenuItemModel {
  MenuItemModel({this.id, this.title = "", required this.riveIcon});

  UniqueKey? id = UniqueKey();
  String title;
  TabItem riveIcon;
}
