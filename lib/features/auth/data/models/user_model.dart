import 'package:ecomm/features/auth/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.username,
    required super.email,
    required super.firstName,
    required super.lastName,
    required super.gender,
    required super.image,
    required super.token,
  });

  factory UserModel.fromJson(
    Map<String, dynamic> json, {
    String fallbackToken = '',
  }) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      gender: json['gender'],
      image: json['image'],
      token: json['accessToken'] ?? json['token'] ?? fallbackToken,
    );
  }

  User toEntity() => User(
    id: id,
    username: username,
    email: email,
    firstName: firstName,
    lastName: lastName,
    gender: gender,
    image: image,
    token: token,
  );
}
