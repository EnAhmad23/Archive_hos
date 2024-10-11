import 'dart:convert';
import 'dart:developer';

class User {
  int id;
  String password;
  String name;
  List<int> auths;
  List<String> stringAuth = [];
  User(
      {required this.id,
      required this.name,
      required this.password,
      required this.auths});
  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'password': password};
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
        id: map['id'],
        name: map['name'],
        password: map['password'],
        auths: List<int>.from(jsonDecode(map['authat'])));
  }
  @override
  String toString() {
    return '$id , $name';
  }

  String get auth {
    log('auths -> ${auths.toString()}');
    // log('stringAuth -> ${stringAuth.toString()}');
    if (auths.contains(5)) {
      return 'Admin';
    }
    if (auths.contains(0)) {
      stringAuth.add('شهداء');
    }
    if (auths.contains(1)) {
      stringAuth.add('جرحى');
    }
    if (auths.contains(2)) {
      stringAuth.add('أطفال');
    }
    if (auths.contains(3)) {
      stringAuth.add('نساء');
    }
    if (auths.contains(4)) {
      stringAuth.add('أورام');
    }
    if (auths.contains(6)) {
      stringAuth.add('جراحات');
    }
    if (auths.contains(7)) {
      stringAuth.add('إعتداءات');
    }
    if (auths.contains(8)) {
      stringAuth.add('وفيات');
    }
    String x = stringAuth.join(',');
    stringAuth.clear();

    return x;
  }
}
