import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../../models/file.dart';
import '../../models/patients.dart';
import '../../models/user.dart';

class DbModel {
  static Database? _db;
  Future<Database?> get db async {
    _db ??= await initDataBase();
    return _db;
  }

  Future<void> ensureDirectoryExists(String path) async {
    final Directory dir =
        Directory(dirname(path)); // Get the directory from the file path

    if (!await dir.exists()) {
      try {
        await dir.create(
            recursive: true); // Create the directory if it doesn't exist
        log('Directory created: ${dir.path}');
      } catch (e) {
        log('Error creating directory: $e');
        throw Exception('Failed to create directory at ${dir.path}');
      }
    }
  }

  initDataBase() async {
    // Define the path to the database file inside the "data" folder
    // String path = r'Y:/db/archive.db';
    String path = r'archive.db';
    // Ensure the directory exists before opening the database
    try {
      await ensureDirectoryExists(path);

      // Open or create the database
      Database myDB = await openDatabase(
        path,
        onCreate: _onCreate,
        version: 1,
      );
      log('Database opened at $path');
      return myDB;
    } catch (e) {
      log('Error opening database: $e');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.dialog(
          AlertDialog(
            title: const Text('Database Error'),
            content:
                Text('Error creating or opening the database at $path: $e'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Get.back(); // Close the dialog
                },
              ),
            ],
          ),
          barrierDismissible: false, // Prevent dismissing by clicking outside
        );
      });
      return null; // Return null in case of an error
    }
  }
  // Future<void> ensureDirectoryExists(String path) async {
  //   final directory = Directory(path);
  //   if (!await directory.exists()) {
  //     await directory.create(recursive: true);
  //   }
  // }

  delDatabase() async {
    String dataBasePath = await getDatabasesPath();
    String path = join(dataBasePath, 'archive.db');
    await deleteDatabase(path);
  }

  _onCreate(Database database, int version) async {
    await database.execute('''
      CREATE TABLE Patients (
        id INTEGER NOT NULL PRIMARY KEY,
        name TEXT NOT NULL
      );
      CREATE TABLE users(
       id INTEGER PRIMARY KEY,
       name TEXT , password TEXT ,authat text
       );
      CREATE TABLE file (
        id INTEGER NOT NULL PRIMARY KEY,
        Patient_id INTEGER NOT NULL,
        Patient_name TEXT,
        Category TEXT CHECK(Category IN ( 'شهداء', 'جرحى', 'نساء', 'أطفال', 'أورام','جراحات','إعتداء','وفيات')),
        date DATE,
        userId INTEGER,
        FOREIGN KEY (Patient_id) REFERENCES Patients(id),
         FOREIGN KEY (userId) REFERENCES users(id)
      );
    ''');
    log('create database');
  }

  Future<int> addPatient(Patient patient) async {
    Database? database = await db;
    int re =
        await database!.rawInsert('''insert into Patients (id,name) values (?,?)
     ''', [patient.id, patient.name]);
    return re;
  }

  Future<void> addAuthatColumn() async {
    // SQL command to add a new column
    Database? database = await db;
    await database?.execute('ALTER TABLE file ADD COLUMN userId INTEGER');
  }

  Future<void> deleteAllUsers() async {
    Database? database = await db;
    await database?.delete('users');
  }

  Future<int> addUser(User user) async {
    Database? database = await db;
    int re = await database!.rawInsert(
        '''insert into Users (id,name,password,authat) values (?,?,?,?)
     ''', [user.id, user.name, user.password, jsonEncode(user.auths)]);
    return re;
  }

  Future<int> updatePatient(Patient patient) async {
    Database? database = await db;
    int re = await database!
        .rawInsert('''update  Patients set  id=?,name=?  where id =?
     ''', [patient.id, patient.name, patient.id]);
    return re;
  }

  Future<int> addFile(AppFile file, User user) async {
    Database? database = await db;
    int re = await database!.rawInsert(
        '''insert into file (id,Patient_id,Patient_name,Category,date,userId) values (?,?,?,?,?,?)
     ''',
        [
          file.id,
          file.patientId,
          file.patientName,
          file.category,
          DateFormat('yyyy-MM-dd').format(file.date),
          user.id
        ]);
    return re;
  }

  Future<List<Map<String, Object?>>> getUsers() async {
    Database? database = await db;
    if (database == null) {
      // Handle the case where the database is not accessible
      if (Get.context != null && !Get.isSnackbarOpen) {
        Get.showSnackbar(const GetSnackBar(
          title: 'Database Error',
          message: 'Database connection is not available.',
          duration: Duration(seconds: 3),
        ));
      }
      return []; // Return an empty list on error
    }

    // Perform the query on the available database
    return await database!.rawQuery('''SELECT * FROM users ''');
  }

  Future<List<Map<String, Object?>>> getUser(int id) async {
    Database? database = await db;
    List<Map<String, Object?>> re =
        await database!.rawQuery('''SELECT * FROM users where id = ? ''', [id]);

    return re;
  }

  Future<List<Map<String, Object?>>> getUsersIds() async {
    Database? database = await db;
    if (database != null) {
      List<Map<String, Object?>> re =
          await database!.rawQuery('''SELECT id FROM users ''');
      return re;
    }

    return [];
  }

  Future<List<Map<String, Object?>>> getUserPassword(int id) async {
    Database? database = await db;
    List<Map<String, Object?>> re = await database!
        .rawQuery('''SELECT password FROM users where id = ?''', [id]);

    return re;
  }

  Future<List<Map<String, Object?>>> getFiles() async {
    Database? database = await db;

    // SQL query to select the desired columns from both tables
    List<Map<String, Object?>> re = await database!.rawQuery('''
    SELECT file.id, 
           users.name AS userName, 
           file.Patient_id AS Patient_id, 
           file.Patient_name AS Patient_name, 
           file.Category AS Category, 
           file.date
    FROM file
    JOIN users ON file.userId = users.id
    LIMIT 10
  ''');

    return re;
  }

  Future<List<Map<String, Object?>>> getDaedFiles() async {
    Database? database = await db;
    List<Map<String, Object?>> re = await database!.rawQuery('''SELECT file.id, 
           users.name AS userName, 
           file.Patient_id AS Patient_id, 
           file.Patient_name AS Patient_name, 
           file.Category AS Category, 
           file.date
    FROM file
    JOIN users ON file.userId = users.id
    where Category = 'شهداء' ''');

    return re;
  }

  Future<List<Map<String, Object?>>> getSurgeryFiles() async {
    Database? database = await db;
    List<Map<String, Object?>> re = await database!.rawQuery('''SELECT file.id, 
           users.name AS userName, 
           file.Patient_id AS Patient_id, 
           file.Patient_name AS Patient_name, 
           file.Category AS Category, 
           file.date
    FROM file
    JOIN users ON file.userId = users.id
    where Category = 'شهداء' ''');

    return re;
  }

  Future<List<Map<String, Object?>>> getAssaultFiles() async {
    Database? database = await db;
    List<Map<String, Object?>> re = await database!.rawQuery('''SELECT file.id, 
           users.name AS userName, 
           file.Patient_id AS Patient_id, 
           file.Patient_name AS Patient_name, 
           file.Category AS Category, 
           file.date
    FROM file
    JOIN users ON file.userId = users.id
    where Category = 'إعتداء' ''');

    return re;
  }

  Future<List<Map<String, Object?>>> getNDaedFiles() async {
    Database? database = await db;
    List<Map<String, Object?>> re = await database!.rawQuery('''SELECT file.id, 
           users.name AS userName, 
           file.Patient_id AS Patient_id, 
           file.Patient_name AS Patient_name, 
           file.Category AS Category, 
           file.date
    FROM file
    JOIN users ON file.userId = users.id
    where Category = 'وفيات' ''');

    return re;
  }

  Future<List<Map<String, Object?>>> getKidsFiles() async {
    Database? database = await db;
    List<Map<String, Object?>> re = await database!.rawQuery('''SELECT file.id, 
            users.name AS userName,  
           file.Patient_id AS Patient_id, 
           file.Patient_name AS Patient_name, 
           file.Category AS Category, 
           file.date
    FROM file
    JOIN users ON file.userId = users.id
    where Category = 'أطفال' ''');

    return re;
  }

  Future<List<Map<String, Object?>>> getWomanFiles() async {
    Database? database = await db;
    List<Map<String, Object?>> re = await database!.rawQuery('''SELECT file.id, 
            users.name AS userName, 
           file.Patient_id AS Patient_id, 
           file.Patient_name AS Patient_name, 
           file.Category AS Category, 
           file.date
    FROM file
   JOIN users ON file.userId = users.id where Category = 'نساء' ''');

    return re;
  }

  Future<List<Map<String, Object?>>> getInjurdFiles() async {
    Database? database = await db;
    List<Map<String, Object?>> re = await database!.rawQuery('''
SELECT file.id, 
           users.name AS userName, 
           file.Patient_id AS Patient_id, 
           file.Patient_name AS Patient_name, 
           file.Category AS Category, 
           file.date
    FROM file
    JOIN users ON file.userId = users.id where Category = 'جرحى' ''');

    return re;
  }

  Future<List<Map<String, Object?>>> getCancerFiles() async {
    Database? database = await db;
    List<Map<String, Object?>> re = await database!.rawQuery('''SELECT file.id, 
            users.name AS userName, 
           file.Patient_id AS Patient_id, 
           file.Patient_name AS Patient_name, 
           file.Category AS Category, 
           file.date
    FROM file
    JOIN users ON file.userId = users.id where Category = 'أورام' ''');

    return re;
  }

  Future<int> getNumOfDeads() async {
    Database? database = await db;
    List<Map<String, Object?>> re = await database!
        .rawQuery('''SELECT count(*) FROM file where  Category = 'شهداء'  ''');
    log('/*- $re');
    return re.isNotEmpty ? re.first.values.first as int : 0;
  }

  Future<int> getNumOfAssault() async {
    Database? database = await db;
    List<Map<String, Object?>> re = await database!
        .rawQuery('''SELECT count(*) FROM file where  Category = 'إعتداء'  ''');
    log('/*- $re');
    return re.isNotEmpty ? re.first.values.first as int : 0;
  }

  Future<int> getNumOfSurgery() async {
    Database? database = await db;
    List<Map<String, Object?>> re = await database!
        .rawQuery('''SELECT count(*) FROM file where  Category = 'جراحات'  ''');
    log('/*- $re');
    return re.isNotEmpty ? re.first.values.first as int : 0;
  }

  Future<int> getNumOfNDeads() async {
    Database? database = await db;
    List<Map<String, Object?>> re = await database!
        .rawQuery('''SELECT count(*) FROM file where  Category = 'وفيات'  ''');
    log('/*- $re');
    return re.isNotEmpty ? re.first.values.first as int : 0;
  }

  Future<int> getNumOfKids() async {
    Database? database = await db;
    List<Map<String, Object?>> re = await database!
        .rawQuery('''SELECT count(*) FROM file where  Category = 'أطفال'  ''');
    log('/*- $re');
    return re.isNotEmpty ? re.first.values.first as int : 0;
  }

  Future<int> getNumOfInjured() async {
    Database? database = await db;
    List<Map<String, Object?>> re = await database!
        .rawQuery('''SELECT count(*) FROM file where  Category = 'جرحى'  ''');
    log('/*- $re');
    return re.isNotEmpty ? re.first.values.first as int : 0;
  }

  Future<int> getNumOfWoman() async {
    Database? database = await db;
    List<Map<String, Object?>> re = await database!
        .rawQuery('''SELECT count(*) FROM file where  Category = 'نساء'  ''');
    log('/*- $re');
    return re.isNotEmpty ? re.first.values.first as int : 0;
  }

  Future<int> getNumOfCancer() async {
    Database? database = await db;
    List<Map<String, Object?>> re = await database!
        .rawQuery('''SELECT count(*) FROM file where  Category = 'أورام'  ''');
    log('/*- $re');
    return re.isNotEmpty ? re.first.values.first as int : 0;
  }

  Future<List<Map<String, Object?>>> getFilesCat(String catoger) async {
    Database? database = await db;
    List<Map<String, Object?>> re = await database!
        .rawQuery('''SELECT * FROM file where Category = ?''', [catoger]);

    return re;
  }

  Future<List<Map<String, Object?>>> getPatients() async {
    Database? database = await db;
    List<Map<String, Object?>> re =
        await database!.rawQuery('''SELECT * FROM Patients ''');

    return re;
  }

  Future<List<Map<String, Object?>>> getNumCategory() async {
    Database? database = await db;
    List<Map<String, Object?>> re = await database!.rawQuery('''SELECT 
    Category, 
    COUNT(*) AS file_count
FROM 
    file
GROUP BY 
    Category;
 ''');

    return re;
  }

  getNumOfFileOFusers() async {
    Database? database = await db;
    List<Map<String, Object?>> re = await database!.rawQuery('''
    SELECT 
        u.name AS user_name,
        COUNT(f.id) AS file_count
    FROM 
        users u
    LEFT JOIN 
        file f ON u.id = f.userId
    where u.id != '1000'    
    GROUP BY 
        u.name;
''');
    return re;
  }

  Future<int> getMaxNumFile() async {
    Database? database = await db;
    List<Map<String, Object?>> re = await database!.rawQuery('''
      SELECT  COUNT(*) as category_count
      FROM file
      ORDER BY category_count DESC
      LIMIT 1;
''');
    return re.isNotEmpty ? re.first.values.first as int : 0;
  }

  getMaxOfCatoger() async {
    Database? database = await db;
    List<Map<String, Object?>> re = await database!.rawQuery('''
    SELECT Category, COUNT(*) as category_count
    FROM file
    GROUP BY Category
    ORDER BY category_count DESC

    ''');
    return re;
  }

  Future<int> updateFile(AppFile file, int newId) async {
    Database? database = await db;
    log('file data base $file');
    log('new id $newId');
    int re = await database!.rawUpdate('''UPDATE file SET 
         id=?, 
         Patient_id=?, 
         Patient_name=?, 
         Category=?, 
         date=? 
       WHERE id = ?''', [
      newId, // New ID to set
      file.patientId,
      file.patientName,
      file.category,
      DateFormat('yyyy-MM-dd').format(file.date),
      file.id // Current ID to find the record
    ]);

    return re;
  }

  updateUser(User user) async {
    Database? datebase = await db;
    int re = await datebase!.rawUpdate(
        'UPDATE users SET authat = ? WHERE id = ?',
        [jsonEncode(user.auths), user.id]);
    return re;
  }

  deleteUser(int id) async {
    Database? database = await db;
    int re =
        await database!.rawDelete('''delete from users where id = ?''', [id]);
    return re;
  }
}
