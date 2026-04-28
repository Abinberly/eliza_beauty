import 'package:eliza_beauty/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.username,
    required super.email,
    required super.firstName,
    required super.lastName,
    required super.gender,
    required super.image,
    required super.accessToken,
    required super.refreshToken,
    super.age,
    super.phone,
    super.birthDate,
    super.bloodGroup,
    super.height,
    super.weight,
    super.role,
    super.companyTitle,
    super.companyDept,
    super.addressText,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] ?? 0,
    username: json['username'] ?? '',
    email: json['email'] ?? '',
    firstName: json['firstName'] ?? '',
    lastName: json['lastName'] ?? '',
    gender: json['gender'] ?? '',
    image: json['image'] ?? '',
    accessToken: json['accessToken'] ?? '',
    refreshToken: json['refreshToken'] ?? '',
    age: json['age'] as int?,
    phone: json['phone'] as String?,
    birthDate: json['birthDate'] as String?,
    bloodGroup: json['bloodGroup'] as String?,
    height: (json['height'] as num?)?.toDouble(),
    weight: (json['weight'] as num?)?.toDouble(),
    role: json['role'] as String?,
    companyTitle: json['company']?['title'] as String?,
    companyDept: json['company']?['department'] as String?,
    addressText: json['address']?['address'] != null 
        ? '${json['address']['address']}, ${json['address']['city']}, ${json['address']['state']}' 
        : null,
  );

  /// Serializes ALL user fields for complete offline profile restoration.
  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'email': email,
    'firstName': firstName,
    'lastName': lastName,
    'gender': gender,
    'image': image,
    'accessToken': accessToken,
    'refreshToken': refreshToken,
    'age': age,
    'phone': phone,
    'birthDate': birthDate,
    'bloodGroup': bloodGroup,
    'height': height,
    'weight': weight,
    'role': role,
    'company': (companyTitle != null || companyDept != null)
        ? {'title': companyTitle, 'department': companyDept}
        : null,
    'address': addressText != null
        ? {
            'address': addressText!.split(', ').firstOrNull ?? '',
            'city': addressText!.split(', ').elementAtOrNull(1) ?? '',
            'state': addressText!.split(', ').elementAtOrNull(2) ?? '',
          }
        : null,
  };

  UserModel copyWith({
    dynamic id,
    String? username,
    String? email,
    String? firstName,
    String? lastName,
    String? gender,
    String? image,
    String? accessToken,
    String? refreshToken,
    int? age,
    String? phone,
    String? birthDate,
    String? bloodGroup,
    double? height,
    double? weight,
    String? role,
    String? companyTitle,
    String? companyDept,
    String? addressText,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      gender: gender ?? this.gender,
      image: image ?? this.image,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      age: age ?? this.age,
      phone: phone ?? this.phone,
      birthDate: birthDate ?? this.birthDate,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      role: role ?? this.role,
      companyTitle: companyTitle ?? this.companyTitle,
      companyDept: companyDept ?? this.companyDept,
      addressText: addressText ?? this.addressText,
    );
  }

  User toEntity() => this;
}
