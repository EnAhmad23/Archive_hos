import 'package:get/get.dart';
import '../../Controllers/patients_controller.dart';
import '../../Controllers/users_controller.dart';

import '../Controllers/file_controller.dart';
import '../Controllers/home_controller.dart';
import '../Controllers/login_controllers.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController(), fenix: true);
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
    Get.lazyPut<FileController>(() => FileController(), fenix: true);
    Get.lazyPut<UsersController>(() => UsersController());
    Get.lazyPut<PatientsController>(() => PatientsController(), fenix: true);
  }
}
