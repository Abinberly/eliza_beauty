class User {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String gender;
  final String image;
  final String accessToken;
  final String refreshToken;
  final int? age;
  final String? phone;
  final String? birthDate;
  final String? bloodGroup;
  final double? height;
  final double? weight;
  final String? role;
  final String? companyTitle;
  final String? companyDept;
  final String? addressText;

  const User({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.image,
    required this.accessToken,
    required this.refreshToken,
    this.age,
    this.phone,
    this.birthDate,
    this.bloodGroup,
    this.height,
    this.weight,
    this.role,
    this.companyTitle,
    this.companyDept,
    this.addressText,
  });
}