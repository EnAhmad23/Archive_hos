import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';
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

  static const String _closedMonthsTable = 'closed_months';

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
        onUpgrade: _onUpgrade,
        version: 2,
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
        key INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT ,
         id INTEGER UNIQUE,
        name TEXT NOT NULL
      );
      CREATE TABLE users(
      
       id INTEGER PRIMARY KEY,
       name TEXT , password TEXT ,authat text
       );
      CREATE TABLE file (
      key INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT ,
        id INTEGER NOT NULL ,
        Patient_key INTEGER NOT NULL,
        Patient_name TEXT,
        Category TEXT CHECK(Category IN ( 'شهداء', 'جرحى', 'نساء', 'أطفال', 'أورام','جراحات','إعتداء','وفيات')),
        date DATE,
        userId INTEGER,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP ,
        FOREIGN KEY (Patient_key) REFERENCES Patients(key),
         FOREIGN KEY (userId) REFERENCES users(id)
      );
      CREATE TABLE closed_months (
        month TEXT NOT NULL PRIMARY KEY,
        closed_at DATETIME DEFAULT CURRENT_TIMESTAMP
      );
    ''');
    log('create database');
  }

  Future<void> _onUpgrade(
      Database database, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await database.execute('''
        CREATE TABLE IF NOT EXISTS closed_months (
          month TEXT NOT NULL PRIMARY KEY,
          closed_at DATETIME DEFAULT CURRENT_TIMESTAMP
        );
      ''');
    }
  }

  String _monthKey(DateTime date) {
    return DateFormat('yyyy-MM').format(date);
  }

  Future<bool> isMonthClosed(String month) async {
    Database? database = await db;
    if (database == null) return false;
    final re = await database.rawQuery(
      'SELECT 1 FROM $_closedMonthsTable WHERE month = ? LIMIT 1',
      [month],
    );
    return re.isNotEmpty;
  }

  Future<List<String>> getClosedMonths() async {
    Database? database = await db;
    if (database == null) return [];
    final re = await database.rawQuery(
      'SELECT month FROM $_closedMonthsTable ORDER BY month ASC',
    );
    return re.map((e) => (e['month'] as String)).toList();
  }

  Future<List<String>> getOpenMonthsWithFiles() async {
    Database? database = await db;
    if (database == null) return [];
    final re = await database.rawQuery('''
      SELECT DISTINCT strftime('%Y-%m', date) AS month
      FROM file
      WHERE NOT EXISTS (
        SELECT 1 FROM $_closedMonthsTable cm
        WHERE cm.month = strftime('%Y-%m', file.date)
      )
      ORDER BY month ASC
    ''');

    return re
        .map((e) => (e['month'] as String? ?? '').trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  Future<String?> getPreviousMonthWithFiles(String month) async {
    Database? database = await db;
    if (database == null) return null;
    final re = await database.rawQuery('''
      SELECT MAX(strftime('%Y-%m', date)) AS month
      FROM file
      WHERE strftime('%Y-%m', date) < ?
    ''', [month]);

    if (re.isEmpty) return null;
    return re.first['month'] as String?;
  }

  Future<bool> canCloseMonth(String month) async {
    if (await isMonthClosed(month)) return false;
    final prev = await getPreviousMonthWithFiles(month);
    if (prev == null) return true;
    return await isMonthClosed(prev);
  }

  Future<int> closeMonth(String month) async {
    Database? database = await db;
    if (database == null) return 0;
    if (!await canCloseMonth(month)) return 0;
    return await database.rawInsert(
      'INSERT OR IGNORE INTO $_closedMonthsTable (month) VALUES (?)',
      [month],
    );
  }

  Future<List<Map<String, Object?>>> searchFiles({
    required String query,
    String? category,
    int limit = 250,
  }) async {
    Database? database = await db;
    if (database == null) return [];
    final like = '%${query.trim()}%';

    if (category != null && category.trim().isNotEmpty) {
      return await database.rawQuery('''
        SELECT file.id,
               users.name AS userName,
               Patients.id AS Patient_id,
               file.Patient_name AS Patient_name,
               file.Category AS Category,
               file.date,
               file.created_at,
               file.Patient_key
        FROM file
        JOIN users ON file.userId = users.id
        JOIN Patients on file.Patient_key = Patients.key
        WHERE file.Category = ?
          AND (
            CAST(file.id AS TEXT) LIKE ?
            OR CAST(Patients.id AS TEXT) LIKE ?
            OR file.Patient_name LIKE ?
            OR file.Category LIKE ?
            OR file.date LIKE ?
            OR users.name LIKE ?
          )
        ORDER BY created_at DESC
        LIMIT ?
      ''', [category, like, like, like, like, like, like, limit]);
    }

    return await database.rawQuery('''
      SELECT file.id,
             users.name AS userName,
             Patients.id AS Patient_id,
             file.Patient_name AS Patient_name,
             file.Category AS Category,
             file.date,
             file.created_at,
             file.Patient_key
      FROM file
      JOIN users ON file.userId = users.id
      JOIN Patients on file.Patient_key = Patients.key
      WHERE (
        CAST(file.id AS TEXT) LIKE ?
        OR CAST(Patients.id AS TEXT) LIKE ?
        OR file.Patient_name LIKE ?
        OR file.Category LIKE ?
        OR file.date LIKE ?
        OR users.name LIKE ?
      )
      ORDER BY created_at DESC
      LIMIT ?
    ''', [like, like, like, like, like, like, limit]);
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
        .rawInsert('''update  Patients set  id=?,name=?  where key =?
     ''', [patient.id, patient.name, patient.key]);
    return re;
  }

  Future<int> addFile(AppFile file, User user) async {
    Database? database = await db;
    String currentMonth = _monthKey(file.date);
    if (await isMonthClosed(currentMonth)) {
      throw Exception('Month is closed');
    }
    int key = await getPatientKey(file.patientId);
    // Query to get the max 'id' for the current month
    final result = await database?.rawQuery('''
    SELECT MAX(id) as maxId FROM file 
    WHERE strftime('%Y-%m', date) = ?
  ''', [currentMonth]);

    int newId = 1; // Default start at 1
    if (result != null && result.isNotEmpty && result.first['maxId'] != null) {
      // Increment the maxId for the current month
      newId = (int.parse('${result.first['maxId']}')) + 1;
    }

    int re = await database!.rawInsert(
        '''insert into file (id,Patient_key,Patient_name,Category,date,userId) values (?,?,?,?,?,?)
     ''',
        [
          newId,
          key,
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
    return await database.rawQuery('''SELECT * FROM users ''');
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
          await database.rawQuery('''SELECT id FROM users ''');
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
           Patients.id AS Patient_id, 
           file.Patient_name AS Patient_name, 
           file.Category AS Category, 
           file.date,
           file.created_at,
           file.Patient_key
    FROM file
    JOIN users ON file.userId = users.id  join Patients on file.Patient_key = Patients.key
    WHERE NOT EXISTS (
      SELECT 1 FROM $_closedMonthsTable cm
      WHERE cm.month = strftime('%Y-%m', file.date)
    )
    order By created_at DESC
   
  ''');

    return re;
  }

  Future<List<Map<String, Object?>>> getDaedFiles() async {
    Database? database = await db;
    List<Map<String, Object?>> re = await database!.rawQuery('''SELECT file.id, 
           users.name AS userName, 
           Patients.id AS Patient_id, 
           file.Patient_name AS Patient_name, 
           file.Category AS Category, 
           file.date
          ,
           file.created_at,
           file.Patient_key
    FROM file
    JOIN users ON file.userId = users.id  join Patients on file.Patient_key = Patients.key
     
    where Category = 'شهداء'
    AND NOT EXISTS (
      SELECT 1 FROM $_closedMonthsTable cm
      WHERE cm.month = strftime('%Y-%m', file.date)
    )
    order By created_at DESC ''');

    return re;
  }

  Future<List<Map<String, Object?>>> getSurgeryFiles() async {
    Database? database = await db;
    List<Map<String, Object?>> re = await database!.rawQuery('''SELECT file.id, 
           users.name AS userName, 
           Patients.id AS Patient_id, 
           file.Patient_name AS Patient_name, 
           file.Category AS Category, 
           file.date,
           file.created_at,
           file.Patient_key
    FROM file
    JOIN users ON file.userId = users.id  join Patients on file.Patient_key = Patients.key
     
    where Category = 'جراحات'
    AND NOT EXISTS (
      SELECT 1 FROM $_closedMonthsTable cm
      WHERE cm.month = strftime('%Y-%m', file.date)
    )
    order By created_at DESC ''');

    return re;
  }

  Future<List<Map<String, Object?>>> getAssaultFiles() async {
    Database? database = await db;
    List<Map<String, Object?>> re = await database!.rawQuery('''SELECT file.id, 
          users.name AS userName, 
           Patients.id AS Patient_id, 
           file.Patient_name AS Patient_name, 
           file.Category AS Category, 
           file.date,
           file.created_at,
           file.Patient_key
    FROM file
    JOIN users ON file.userId = users.id  join Patients on file.Patient_key = Patients.key
    
    where Category = 'إعتداء'
    AND NOT EXISTS (
      SELECT 1 FROM $_closedMonthsTable cm
      WHERE cm.month = strftime('%Y-%m', file.date)
    )
     order By created_at DESC ''');

    return re;
  }

  Future<List<Map<String, Object?>>> getNDaedFiles() async {
    Database? database = await db;
    List<Map<String, Object?>> re = await database!.rawQuery('''SELECT file.id, 
          users.name AS userName, 
           Patients.id AS Patient_id, 
           file.Patient_name AS Patient_name, 
           file.Category AS Category, 
           file.date,
           file.created_at,
           file.Patient_key
    FROM file
    JOIN users ON file.userId = users.id  join Patients on file.Patient_key = Patients.key
    where Category = 'وفيات'
    AND NOT EXISTS (
      SELECT 1 FROM $_closedMonthsTable cm
      WHERE cm.month = strftime('%Y-%m', file.date)
    )
     order By created_at DESC
      ''');

    return re;
  }

  Future<List<Map<String, Object?>>> getKidsFiles() async {
    Database? database = await db;
    List<Map<String, Object?>> re = await database!.rawQuery('''SELECT file.id, 
          users.name AS userName, 
           Patients.id AS Patient_id, 
           file.Patient_name AS Patient_name, 
           file.Category AS Category, 
           file.date,
           file.created_at,
           file.Patient_key
    FROM file
    JOIN users ON file.userId = users.id  join Patients on file.Patient_key = Patients.key
    where Category = 'أطفال'
    AND NOT EXISTS (
      SELECT 1 FROM $_closedMonthsTable cm
      WHERE cm.month = strftime('%Y-%m', file.date)
    )
     order By created_at DESC
      ''');

    return re;
  }

  Future<List<Map<String, Object?>>> getWomanFiles() async {
    Database? database = await db;
    List<Map<String, Object?>> re = await database!.rawQuery('''SELECT file.id, 
           users.name AS userName, 
           Patients.id AS Patient_id, 
           file.Patient_name AS Patient_name, 
           file.Category AS Category, 
           file.date,
           file.created_at,
           file.Patient_key
    FROM file
    JOIN users ON file.userId = users.id  join Patients on file.Patient_key = Patients.key 
    where Category = 'نساء'
    AND NOT EXISTS (
      SELECT 1 FROM $_closedMonthsTable cm
      WHERE cm.month = strftime('%Y-%m', file.date)
    )
     order By created_at DESC
      ''');

    return re;
  }

  Future<List<Map<String, Object?>>> getInjurdFiles() async {
    Database? database = await db;
    List<Map<String, Object?>> re = await database!.rawQuery('''
SELECT file.id, 
          users.name AS userName, 
           Patients.id AS Patient_id, 
           file.Patient_name AS Patient_name, 
           file.Category AS Category, 
           file.date,
           file.created_at,
           file.Patient_key
    FROM file
    JOIN users ON file.userId = users.id  join Patients on file.Patient_key = Patients.key 
    where Category = 'جرحى'
    AND NOT EXISTS (
      SELECT 1 FROM $_closedMonthsTable cm
      WHERE cm.month = strftime('%Y-%m', file.date)
    )
     order By created_at DESC
      ''');

    return re;
  }

  Future<List<Map<String, Object?>>> getCancerFiles() async {
    Database? database = await db;
    List<Map<String, Object?>> re = await database!.rawQuery('''SELECT file.id, 
            users.name AS userName, 
           Patients.id AS Patient_id, 
           file.Patient_name AS Patient_name, 
           file.Category AS Category, 
           file.date,
           file.created_at,
           file.Patient_key
    FROM file
    JOIN users ON file.userId = users.id  join Patients on file.Patient_key = Patients.key 
    where Category = 'أورام'
    AND NOT EXISTS (
      SELECT 1 FROM $_closedMonthsTable cm
      WHERE cm.month = strftime('%Y-%m', file.date)
    )
     order By created_at DESC
      ''');

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
    List<Map<String, Object?>> re = await database!.rawQuery('''
      SELECT * FROM file
      WHERE Category = ?
      AND NOT EXISTS (
        SELECT 1 FROM $_closedMonthsTable cm
        WHERE cm.month = strftime('%Y-%m', file.date)
      )
    ''', [catoger]);

    return re;
  }

  Future<List<Map<String, Object?>>> getPatients() async {
    Database? database = await db;
    List<Map<String, Object?>> re =
        await database!.rawQuery('''SELECT * FROM Patients ''');

    return re;
  }

  Future<int> getPatientKey(int id) async {
    Database? database = await db;
    List<Map<String, Object?>> re = await database!
        .rawQuery('''SELECT key FROM Patients where id = ? ''', [id]);

    return re.isNotEmpty ? re.first.values.first as int : 0;
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
      SELECT COUNT(*) as category_count
      FROM file
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

    if (await isMonthClosed(_monthKey(file.date))) {
      throw Exception('Month is closed');
    }

    int re = await database!.rawUpdate('''UPDATE file SET 
         id=?, 
       
         Patient_name=?, 
         Category=?, 
         date=? 
       WHERE id = ?''', [
      newId, // New ID to set
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
