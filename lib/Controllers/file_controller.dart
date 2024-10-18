import 'dart:developer';
import 'dart:io';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:sqflite/sqflite.dart';
import '../../Controllers/patients_controller.dart';
import '../../models/database_model.dart';
import '../../models/file.dart';
import '../../models/patients.dart';
import '../../models/user.dart';
import '../Ui/Widget/done_snackBar.dart';
// import 'package:file_picker/file_picker.dart';

class FileController extends GetxController {
  final DbModel _dbModel = DbModel();
  final List<String> catogers = [
    'شهداء',
    'جرحى',
    'أطفال',
    'نساء',
    'أورام',
    'اختر الفئة'
  ];
  GlobalKey<FormState> fromKey = GlobalKey();
  int? _id;
  int? _patientID;
  int? _numOfDeads;
  int? _numOfKids;
  int? _numOfInjured;
  int? _numOfWoman;
  int? _numOfCancer;
  int? patientKey;
  int? _numOfSurgery;
  int? _numOfAssault;
  int? _numOfNDead;
  late double maxNum;
  String? _patientName;
  String? _catoger;
  DateTime? _date;
  List<AppFile>? files;
  final RxList<String> _items = <String>[].obs;
  RxList<AppFile> filteredItems = <AppFile>[].obs;
  List<AppFile>? daeds;
  List<AppFile>? kids;
  List<AppFile>? womans;
  List<AppFile>? injureds;
  List<AppFile>? cancers;
  List<AppFile>? surgery;
  List<AppFile>? assault;
  List<AppFile>? nDead;
  var isLoading = true.obs;
  List<Map<String, dynamic>>? numberOfFileOfUsers;
  List<Map<String, dynamic>>? numForCatoger;
  TextEditingController fileNameController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController patientIdController = TextEditingController();
  TextEditingController patientNameController = TextEditingController();
  TextEditingController catogerController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  Future<void> loadData() async {
    isLoading.value = true;
    // Fetch data
    await getNumOfFileOfUsers();
    await getNumCategory();
    await getMaxNumFile();
    isLoading.value = false;
  }

  void filterItems(String query, List<AppFile>? list) {
    if (query.isEmpty) {
      // if (list!.isNotEmpty) {
      filteredItems.assignAll(list ?? []);
      log('Filtered items length (empty query): ${filteredItems.length}');
      // }
    } else {
      filteredItems.assignAll(
        list
                ?.where((file) => file.toString().contains(query))
                .map((file) => file)
                .toList() ??
            [],
      );
    }
    log('filteredItems -> ${filteredItems.toString()}');
  }

  set id(int? id) {
    _id = id;
    update();
  }

  set patientID(int? patientID) {
    _patientID = patientID;
    update();
  }

  set patientName(String? patientName) {
    _patientName = patientName;
    update();
  }

  set catoger(String? catoger) {
    _catoger = catoger;
    update();
  }

  set numOfDeads(int? num) {
    _numOfDeads = num;
    update();
  }

  set numOfNDeads(int? num) {
    _numOfNDead = num;
    update();
  }

  set numOfSurgery(int? num) {
    _numOfSurgery = num;
    update();
  }

  set numOfAssault(int? num) {
    _numOfAssault = num;
    update();
  }

  set numOfKids(int? num) {
    _numOfKids = num;
    update();
  }

  set numOfWoman(int? num) {
    _numOfWoman = num;
    update();
  }

  set numOfInjured(int? num) {
    _numOfInjured = num;
    update();
  }

  set numOfCancer(int? num) {
    _numOfCancer = num;
    update();
  }

  set date(DateTime? date) {
    _date = date;
    update();
  }

  set hintDate(String? text) {
    if (text != null) {
      update();
    }
  }

  int get id {
    return _id ?? 0;
  }

  int get patientID {
    return _patientID ?? 0;
  }

  int get numOfDeads {
    return _numOfDeads ?? 0;
  }

  int get numOfKids {
    return _numOfKids ?? 0;
  }

  int get numOfInjured {
    return _numOfInjured ?? 0;
  }

  int get numOfWoman {
    return _numOfWoman ?? 0;
  }

  int get numOfCancer {
    return _numOfCancer ?? 0;
  }

  String get patientName {
    return _patientName ?? '';
  }

  String? get catoger {
    return _catoger;
  }

  DateTime? get date {
    return _date ?? DateTime.now();
  }

  String get hintData {
    return (_date) == null
        ? 'YYYY-MM-DD'
        : DateFormat('yyyy-MM-dd').format(_date ?? DateTime.now());
  }

  String? dateValidet(String? value) {
    if (hintData == 'YYYY-MM-DD' || hintData.isEmpty) {
      return 'الرجاء اختيار التاريخ ';
    }
    return null;
  }

  String? fileIdValidet(String? value) {
    if (value == null || value.isEmpty) {
      return 'الرجاء ادخال رقم الملف ';
    }
    return null;
  }

  String? patientsIdValidet(String? value) {
    if (value == null || value.isEmpty) {
      return 'الرجاء ادخال رقم الهوية ';
    } else if (value.length != 9) {
      return 'رقم يجب ان يكون 9 ارقام';
    }
    return null;
  }

  String? patientNameValidet(String? value) {
    if (value == null || value.isEmpty) {
      return 'الرجاء ادخال الاسم';
    }
    return null;
  }

  // addUser(User user) async {
  //   user.password = hashPassword(user.password);
  //   int x = await _dbModel.addUser(user);
  //   log('$x');
  //   return x;
  // }

  // String hashPassword(String password) {
  //   final bytes = utf8.encode(password); // Convert password to bytes
  //   final digest = sha256.convert(bytes); // Perform SHA-256 hashing
  //   return digest.toString(); // Convert the digest to a string
  // }

  Future<void> getFiles() async {
    List<Map<String, Object?>> re = await _dbModel.getFiles();
    files = re
        .map(
          (e) => AppFile.fromMap(e),
        )
        .toList();
    update();
  }

  Future<void> getDeadsFiles() async {
    List<Map<String, Object?>> re = await _dbModel.getDaedFiles();
    daeds = re
        .map(
          (e) => AppFile.fromMap(e),
        )
        .toList();
    update();
    log(' daeds  -> ${daeds?.length}');
  }

  Future<void> getKidsFiles() async {
    List<Map<String, Object?>> re = await _dbModel.getKidsFiles();
    kids = re
        .map(
          (e) => AppFile.fromMap(e),
        )
        .toList();
    update();
  }

  Future<void> getWomansFiles() async {
    List<Map<String, Object?>> re = await _dbModel.getWomanFiles();
    womans = re
        .map(
          (e) => AppFile.fromMap(e),
        )
        .toList();
    update();
  }

  Future<void> getCancerFiles() async {
    List<Map<String, Object?>> re = await _dbModel.getCancerFiles();
    cancers = re
        .map(
          (e) => AppFile.fromMap(e),
        )
        .toList();
    update();
  }

  Future<void> getInjuredFiles() async {
    List<Map<String, Object?>> re = await _dbModel.getInjurdFiles();
    injureds = re
        .map(
          (e) => AppFile.fromMap(e),
        )
        .toList();
    update();
  }

  Future<void> getSurgeryFiles() async {
    List<Map<String, Object?>> re = await _dbModel.getSurgeryFiles();
    surgery = re
        .map(
          (e) => AppFile.fromMap(e),
        )
        .toList();
    update();
  }

  Future<void> getAssaultFiles() async {
    List<Map<String, Object?>> re = await _dbModel.getAssaultFiles();
    assault = re
        .map(
          (e) => AppFile.fromMap(e),
        )
        .toList();
    update();
  }

  Future<void> getNDeadFiles() async {
    List<Map<String, Object?>> re = await _dbModel.getNDaedFiles();
    nDead = re
        .map(
          (e) => AppFile.fromMap(e),
        )
        .toList();
    update();
  }

  getNumOfDeads() async {
    int? x = await _dbModel.getNumOfDeads();
    numOfDeads = x;
    update();
    return x;
  }

  getNumOfKids() async {
    int? x = await _dbModel.getNumOfKids();
    numOfKids = x;
    update();
    return x;
  }

  getNumOfWoman() async {
    int? x = await _dbModel.getNumOfWoman();
    numOfWoman = x;
    update();
    return x;
  }

  getNumOfCancer() async {
    int? x = await _dbModel.getNumOfCancer();
    numOfCancer = x;
    update();
    return x;
  }

  getNumOfSurgery() async {
    int? x = await _dbModel.getNumOfSurgery();
    numOfSurgery = x;
    update();
    return x;
  }

  getNumOfAssault() async {
    int? x = await _dbModel.getNumOfAssault();
    numOfAssault = x;
    update();
    return x;
  }

  getNumOfNDead() async {
    int? x = await _dbModel.getNumOfNDeads();
    numOfNDeads = x;
    update();
    return x;
  }

  getNumOfInjured() async {
    int? x = await _dbModel.getNumOfInjured();
    numOfInjured = x;
    update();
    return x;
  }

  void getFilesCat(String catoger) async {
    List<Map<String, Object?>> re = await _dbModel.getFilesCat(catoger);
    if (re.isNotEmpty) {
      files = re
          .map(
            (e) => AppFile.fromMap(e),
          )
          .toList();

      // Safely update _items with the new list of file strings
      _items.assignAll(files!.map((e) => e.toString()).toList());
    } else {
      // Handle case when no files are returned
      _items.clear();
    }
    update();
  }

  getNumCategory() async {
    List<Map<String, Object?>> re = await _dbModel.getNumCategory();
    numForCatoger = re;
    update();
  }

  getMaxNumFile() async {
    maxNum = (await _dbModel.getMaxNumFile()).toDouble();
    update();
  }

  getNumOfFileOfUsers() async {
    List<Map<String, Object?>> re = await _dbModel.getNumOfFileOFusers();
    numberOfFileOfUsers = re;
    update();
  }

  Future<int> addFile(AppFile file, User user) async {
    int x = await _dbModel.addFile(file, user);
    log('$x');
    return x;
  }

  Future<int> updateFile(AppFile file, int newId) async {
    int x = await _dbModel.updateFile(file, newId);
    log(file.toString());
    log('$x');
    return x;
  }

  initData(AppFile file) {
    idController.text = '${file.id}';
    patientIdController.text = '${file.patientId}';
    patientNameController.text = file.patientName;
    catoger = file.category;
    date = file.date;
    patientKey = file.patientKey;
  }

  clearTextFiled() {
    idController.clear();
    patientIdController.clear();
    patientNameController.clear();
    catogerController.clear();
    hintDate = 'YYYY-MM-DD';
    update();
  }

  clearData() {
    id = null;
    patientID = null;
    patientName = null;
    catoger = null;
    date = null;
    update();
  }

  Future<void> pickAndReadExcel(User user, String? category) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
    );
    log('file -> selected $result');
    if (result != null) {
      File file = File(result.files.single.path!);
      var bytes = file.readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);
      log('file -> read ');
      List<AppFile> tempData = [];
      for (var table in excel.tables.keys) {
        // log('file -> reading ${excel.tables[table]!.rows} ');
        var rows = excel.tables[table]!.rows;
        log('file -> rows ${rows.length} ');
        for (var i = 1; i < rows.length; i++) {
          // Skip the header row
          var row = rows[i];

          tempData.add(AppFile(
            id: int.parse(row[0]?.value.toString() ?? '0'),
            patientId: int.parse(row[1]?.value.toString() ?? '0'),
            patientName: row[2]?.value.toString() ?? '',
            category: category ?? '',
            date: DateTime.tryParse(row[3]?.value.toString() ?? '') ??
                DateTime.now(),
            userName: user.name,
          ));
        }
      }
      for (var file in tempData) {
        PatientsController()
            .addPatient(Patient(name: file.patientName, id: file.patientId));
        addFile(file, user);
      }
    }
    getFiles();
    getDeadsFiles();
    getInjuredFiles();
    getKidsFiles();
    getWomansFiles();
    getCancerFiles();
    filterItems('', files);
    filterItems('', daeds);
    filterItems('', injureds);
    filterItems('', kids);
    filterItems('', womans);
  }

  Future<void> exportFileTableToExcel(String fileName) async {
    DbModel dbModel = DbModel();
    await dbModel.initDataBase();

    // Check for storage permission

    if (await Permission.storage.request().isGranted) {
      // Let the user pick a directory where the file will be saved
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

      if (selectedDirectory != null) {
        var excel = Excel.createExcel();

        String sheetName = "Sheet1";

        // Create or access the sheet
        Sheet sheetObject = excel[sheetName];
        sheetObject.isRTL = true;
        // Add headers
        sheetObject.appendRow([
          TextCellValue('رقم الملف'),
          TextCellValue('رقم الهوية'),
          TextCellValue('الأسم'),
          TextCellValue('الفئة'),
          TextCellValue('التاريخ'),
        ]);
        await getFiles();
        // Ensure files is not null before proceeding
        if (files != null) {
          // Add data rows from the file table
          for (var row in files!) {
            sheetObject.appendRow([
              IntCellValue(int.parse('${row.id}')),
              IntCellValue(int.parse('${row.patientId}')),
              TextCellValue(row.patientName),
              TextCellValue(row.category),
              TextCellValue(DateFormat('yyyy-MM-dd').format(row.date)),
            ]);
          }

          if (fileNameController.text.isNotEmpty) {
            // Save the file in the selected directory
            String filePath = '$selectedDirectory/$fileName.xlsx';

            // Save the file
            File(filePath)
              ..createSync(recursive: true)
              ..writeAsBytesSync(excel.encode()!);

            Get.showSnackbar(
              GetSnackBar(
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
                titleText: Text(
                  'تم',
                  style:
                      TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                ),
                messageText: Text(
                  "$filePath  تم تصدير ملف الاكسل الى : ",
                  style: TextStyle(fontSize: 20.sp),
                ),
                maxWidth: 800.w,
                // title: 'Success',
                // message: 'File update successfully!',
                icon: Lottie.asset(
                  'assets/json/check.json',
                ),
                backgroundColor: Colors.white,
                snackPosition: SnackPosition.BOTTOM,
                borderRadius: 10,
                margin: const EdgeInsets.all(16),
                duration: const Duration(seconds: 3),
                isDismissible: true,
                dismissDirection: DismissDirection.horizontal,
                mainButton: TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text(
                    'إغلاق',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            );
            print("$filePath  تم تصدير ملف الاكسل الى : ");
          } else {
            print("File name is empty.");
          }
        } else {
          print("No files data available to export.");
        }
      } else {
        print("No directory selected.");
      }
    } else {
      print("Storage permission denied.");
    }
  }
}
