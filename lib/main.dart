import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:test_2/Ui/Screens/login.dart';

import 'Controllers/login_controllers.dart';
import 'models/database_model.dart';
import 'models/user.dart';
import 'utils/bindings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  doWhenWindowReady(() {
    final win = appWindow;
    const initialSize = Size(1000, 800);
    win.minSize = initialSize;
    win.maximize();
    // win.size = initialSize;
    // win.alignment = Alignment.center;
    win.title = "أرشيف";
    win.show();
  });
  var database = await DbModel().initDataBase();

  if (database != null) {
    LoginController loginController = LoginController();
    var check = await loginController.checkUserIn('900223678');

    if (!check) {
      loginController.addUser(User(
          id: 900223678,
          name: 'أبو راشد',
          password: '900223678',
          auths: [0, 1, 2, 3, 4, 5, 6, 7, 8]));
    }
    var adminCheck = await loginController.checkUserIn('1000');
    if (!adminCheck) {
      loginController.addUser(User(
          id: 1000,
          name: 'قسم الحاسوب',
          password: '1000',
          auths: [0, 1, 2, 3, 4, 5, 6, 7, 8]));
    }
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1920, 1080),
      minTextAdapt: true,
      splitScreenMode: true,
      // Use builder only if you need to use library outside ScreenUtilInit context
      builder: (_, child) {
        return GetMaterialApp(
          initialBinding: MainBinding(),
          theme: ThemeData(scaffoldBackgroundColor: Colors.white70),
          debugShowCheckedModeBanner: false,
          home: const LoginScreen(),
        );
      },
    );
  }
}
