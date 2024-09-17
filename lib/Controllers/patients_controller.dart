import 'dart:developer';

import 'package:get/get_state_manager/get_state_manager.dart';
import '../../models/database_model.dart';
import '../../models/patients.dart';

class PatientsController extends GetxController {
  final DbModel _dbModel = DbModel();
  List<Patient>? patients;

  void getPatient() async {
    List<Map<String, Object?>> re = await _dbModel.getPatients();
    patients = re
        .map(
          (e) => Patient.fromMap(e),
        )
        .toList();
    update();
  }

  Future<int> addPatient(Patient patient) async {
    int x = await _dbModel.addPatient(patient);
    log('$x');
    return x;
  }

  Future<int> updatePatient(Patient patient) async {
    int x = await _dbModel.updatePatient(patient);
    log('$x');
    return x;
  }
}
