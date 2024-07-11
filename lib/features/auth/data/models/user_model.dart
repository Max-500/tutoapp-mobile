import 'package:tuto_app/features/auth/domain/entities/user.dart';

class UserModel extends User {
  
  UserModel({required super.uuid, required super.firstname, required super.lastname, required super.email, required super.role, required super.password});

  factory UserModel.fromJSON(Map<String, dynamic> json) {
    return UserModel(
      uuid: json['uuid'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      email: json['email'],
      role: json['role'],
      password: ''
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'uuid': uuid,
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'role': role,
      'password': password
    };
  }

}