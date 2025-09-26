// lib/api/patient_model.dart

class Patient {
  final String id;
  final String name;

  Patient({
    required this.id,
    required this.name,
  });

  // A factory constructor for creating a new Patient instance from a map.
  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }
}