class UserDetails {
  final int id;
  final String firstName;
  final String lastName;
  final String? maidenName;
  final int? age;
  final String? gender;
  final String email;
  final String? phone;
  final String username;
  final DateTime? birthDate;
  final String? image;
  final String? bloodGroup;
  final double? height;
  final double? weight;
  final String? eyeColor;

  const UserDetails({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.maidenName,
    this.age,
    this.gender,
    required this.email,
    this.phone,
    required this.username,
    this.birthDate,
    this.image,
    this.bloodGroup,
    this.height,
    this.weight,
    this.eyeColor,
  });

  /// -------- Parsing --------
  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      maidenName: json['maidenName'],
      age: json['age'],
      gender: json['gender'],
      email: json['email'],
      phone: json['phone'],
      username: json['username'],
      birthDate: json['birthDate'] != null
          ? DateTime.tryParse(json['birthDate'])
          : null,
      image: json['image'],
      bloodGroup: json['bloodGroup'],
      height: (json['height'] as num?)?.toDouble(),
      weight: (json['weight'] as num?)?.toDouble(),
      eyeColor: json['eyeColor'],
    );
  }

  /// -------- Optional: toJson --------
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'maidenName': maidenName,
      'age': age,
      'gender': gender,
      'email': email,
      'phone': phone,
      'username': username,
      'birthDate': birthDate?.toIso8601String(),
      'image': image,
      'bloodGroup': bloodGroup,
      'height': height,
      'weight': weight,
      'eyeColor': eyeColor,
    };
  }

  /// -------- Helper --------
  String get fullName => '$firstName $lastName';
}
