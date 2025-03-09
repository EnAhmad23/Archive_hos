import 'dart:convert';
import 'dart:developer';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/database_model.dart';

import '../models/user.dart';

class UsersController extends GetxController {
  final DbModel _dbModel = DbModel();
  User? _currentUser;
  late List<User> users;
  TextEditingController searchController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController conPasswordController = TextEditingController();
  GlobalKey<FormState> fromKey = GlobalKey();
  int? _id;
  String? _password;
  String? _name;
  bool dead = false;
  bool injured = false;
  bool kids = false;
  bool woman = false;
  bool cancer = false;
  bool statistics = false;
  bool surgery = false;
  bool assault = false;
  bool nDead = false;
  List<int> authList = [];
  List<int> updateAuth = [];

  set id(int? id) {
    _id = id;
    update();
  }

  set password(String? password) {
    _password = password;
    update();
  }

  set name(String? name) {
    _name = name;
    update();
  }

  int get id {
    return _id ?? 0;
  }

  String get name {
    return _name ?? '';
  }

  String get password {
    return _password ?? '';
  }

  changDead(bool value) {
    dead = value;
    update();
  }

  changInjured(bool value) {
    injured = value;
    update();
  }

  changKids(bool value) {
    kids = value;
    update();
  }

  changWoman(bool value) {
    woman = value;
    update();
  }

  changCancer(bool value) {
    cancer = value;
    update();
  }

  changSurgery(bool value) {
    surgery = value;
    update();
  }

  changStatistics(bool value) {
    statistics = value;
    update();
  }

  changAssault(bool value) {
    assault = value;
    update();
  }

  changNDead(bool value) {
    nDead = value;
    update();
  }

  String? userIdValidet(String? value) {
    if (value != null && value.isEmpty) {
      return 'الرجاء ادخال رقم المستخدم ';
    }
    return null;
  }

  String? userNameValidet(String? value) {
    if (value != null && value.isEmpty) {
      return 'الرجاء ادخال  اسم المستخدم ';
    }
    return null;
  }

  String? passwordValidet(String? value) {
    if (value != null && value.isEmpty) {
      return 'الرجاء كلمة المرور';
    }
    return null;
  }

  String? conPasswordValidet(String? value) {
    if (value != null && value.isEmpty) {
      return 'الرجاء تاكيد كلمة المرور';
    } else if (conPasswordController.text != passwordController.text) {
      return 'كلمة المرور غير متطابقة';
    }
    return null;
  }

  // TextEditingController searchController = TextEditingController();
  RxList<User> filteredItems = <User>[].obs;
  set currentUser(User? user) {
    _currentUser = user;
  }

  void filterItems(String query, List<User> list) {
    if (query.isEmpty) {
      // if (list!.isNotEmpty) {
      filteredItems.assignAll(list ?? []);
      log('Filtered items length (empty query): ${filteredItems.length}');
      // }
    } else {
      filteredItems.assignAll(
        list
            .where((user) => user.toString().contains(query))
            .map((user) => user)
            .toList(),
      );
    }
  }

  User? get currentUser {
    return _currentUser;
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

  getUsers() async {
    List<Map<String, Object?>> re = await _dbModel.getUsers();
    users = re
        .map(
          (e) => User.fromMap(e),
        )
        .toList();
    update();
  }

  getuser(int id) async {
    List<Map<String, Object?>> re = await _dbModel.getUser(id);
    List<User>? temp = re
        .map(
          (e) => User.fromMap(e),
        )
        .toList();
    if (temp.isNotEmpty) {
      currentUser = temp.first;
    } else {
      // Handle the case where no user is found, maybe log an error or show a message
      log('User not found');
      currentUser = null;
    }
    update();
  }

  Future<int> updateUser(User user) async {
    int x = await _dbModel.updateUser(user);
    log('update -> $x');
    return x;
  }

  Future<int> deleteUser(int id) async {
    int x = await _dbModel.deleteUser(id);
    log('delete -> $x');
    return x;
  }

  addAuth() {
    if (dead) {
      authList.add(0);
    }
    if (injured) {
      authList.add(1);
    }
    if (kids) {
      authList.add(2);
    }
    if (woman) {
      authList.add(3);
    }
    if (cancer) {
      authList.add(4);
    }
    if (surgery) {
      authList.add(6);
    }
    if (assault) {
      authList.add(7);
    }
    if (nDead) {
      authList.add(8);
    }
    if (statistics) {
      authList.add(9);
    }
  }

  addUpdateAuth() {
    if (dead) {
      updateAuth.add(0);
    }
    if (injured) {
      updateAuth.add(1);
    }
    if (kids) {
      updateAuth.add(2);
    }
    if (woman) {
      updateAuth.add(3);
    }
    if (cancer) {
      updateAuth.add(4);
    }
    if (surgery) {
      updateAuth.add(6);
    }
    if (assault) {
      updateAuth.add(7);
    }
    if (nDead) {
      updateAuth.add(8);
    }
    if (statistics) {
      authList.add(9);
    }
  }

  initData(User user) {
    if (user.auths.contains(0)) {
      changDead(true);
    }
    if (user.auths.contains(1)) {
      changInjured(true);
    }
    if (user.auths.contains(2)) {
      changKids(true);
    }
    if (user.auths.contains(3)) {
      changWoman(true);
    }
    if (user.auths.contains(4)) {
      changCancer(true);
    }
    if (user.auths.contains(6)) {
      changSurgery(true);
    }
    if (user.auths.contains(7)) {
      changAssault(true);
    }
    if (user.auths.contains(8)) {
      changNDead(true);
    }
    if (user.auths.contains(9)) {
      changStatistics(true);
    }
  }

  clearTextFiled() {
    idController.clear();
    nameController.clear();
    passwordController.clear();
    conPasswordController.clear();
    update();
  }

  clearData() {
    id = null;
    name = null;
    password = null;
    update();
  }
}
