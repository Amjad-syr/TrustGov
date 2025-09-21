class User {
  final String nationalId;
  final String firstName;
  final String lastName;
  final String fatherName;
  final String motherFullName;
  final String gender;
  final DateTime birthDate;
  final String idNumber;
  final String specialFeatures;

  User({
    required this.nationalId,
    required this.firstName,
    required this.lastName,
    required this.fatherName,
    required this.motherFullName,
    required this.gender,
    required this.birthDate,
    required this.idNumber,
    required this.specialFeatures,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      nationalId: json['national_id']?.toString() ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      fatherName: json['father_name'] ?? '',
      motherFullName: json['mother_full_name'] ?? '',
      gender: json['gender'] ?? '',
      birthDate:
          DateTime.tryParse(json['birth_date'] ?? '') ?? DateTime(1900, 1, 1),
      idNumber: json['id_number']?.toString() ?? '',
      specialFeatures: json['special_features'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'national_id': nationalId,
      'first_name': firstName,
      'last_name': lastName,
      'father_name': fatherName,
      'mother_full_name': motherFullName,
      'gender': gender,
      'birth_date': birthDate.toIso8601String(),
      'id_number': idNumber,
      'special_features': specialFeatures,
    };
  }
}
