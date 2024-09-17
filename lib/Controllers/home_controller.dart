import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final List<Widget?> pages = [Container()];
  int _index = 0;
  set index(int num) {
    _index = num;
    update();
  }

  int get index => _index;
}
