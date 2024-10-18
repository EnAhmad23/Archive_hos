import 'package:intl/intl.dart';

class AppFile {
  final int? id;
  final String userName;
  final int patientId;
  final int? patientKey;

  final String patientName;
  final String category;
  final DateTime date;

  AppFile({
    this.patientKey,
    required this.userName,
    this.id,
    required this.patientId,
    required this.patientName,
    required this.category,
    required this.date,
  });

  // Convert a FileModel object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'Patient_id': patientId,
      'Patient_key': patientKey,
      'Patient_name': patientName,
      'Category': category,
      'date': date,
      'userName': userName,
    };
  }

  factory AppFile.fromMap(Map<String, dynamic> map) {
    return AppFile(
      id: map['id'],
      patientId: map['Patient_id'],
      patientName: map['Patient_name'] ?? '',
      category: map['Category'],
      date: DateTime.parse(map['date'].toString()),
      userName: map['userName'],
      patientKey: map['Patient_key'],
    );
  }
  String? get formattedDate {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  @override
  String toString() {
    return '$id, $patientId, $patientName, $category, $formattedDate';
  }
}
