class Patient {
  int? id;
  String name;

  Patient({required this.id, required this.name});
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'name': name,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  factory Patient.fromMap(Map<String, dynamic> map) {
    return Patient(
      id: map['id'],
      name: map['name'],
    );
  }
}
