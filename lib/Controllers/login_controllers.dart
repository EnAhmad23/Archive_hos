import 'dart:convert';
import 'dart:developer';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/database_model.dart';
import '../models/user.dart';

class LoginController extends GetxController {
  LoginController() {
    getUsers();
    getIds();
  }
  final DbModel _dbModel = DbModel();
  List<User>? users;
  List<String>? ids;
  TextEditingController idController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> form = GlobalKey();

  getUsers() async {
    List<Map<String, Object?>> re = await _dbModel.getUsers();
    users = re
        .map(
          (e) => User.fromMap(e),
        )
        .toList();
    update();
  }

  getIds() async {
    List<Map<String, Object?>> re = await _dbModel.getUsersIds();
    ids = re
        .map(
          (e) => ('${e['id']}'),
        )
        .toList();
    log('$ids');
    update();
  }

  bool checkUser(String id, String password) {
    if (users != null && ids!.contains(id)) {
      User temp = users!.firstWhere(
        (element) => '${element.id}' == id,
      );
      return temp.password == hashPassword(password);
    }
    return false;
  }

  Future<bool> checkUserIn(String id) async {
    await getIds();

    return (ids != null && ids!.contains(id));
  }

  addUser(User user) async {
    user.password = hashPassword(user.password);
    log(user.password);
    int x = await _dbModel.addUser(user);
    log('$x');
    return x;
  }

  String hashPassword(String password) {
    final bytes = utf8.encode(password); // Convert password to bytes
    final digest = sha256.convert(bytes); // Perform SHA-256 hashing
    return digest.toString(); // Convert the digest to a string
  }

  String? validUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال اسم المستخدم';
    } else if (!ids!.contains(value)) {
      return ' اسم المستخدم غير موجود';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال كلمة المرور';
    } else if (users
            ?.firstWhere(
              (element) => '${element.id}' == idController.text,
            )
            .password !=
        hashPassword(value)) {
      return 'خطأ في كلمة المرور';
    }
    return null;
  }
}
