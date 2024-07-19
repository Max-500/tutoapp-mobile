enum UserRole {
  student('student'),
  tutor('tutor');

  final String value;
  const UserRole(this.value);
}

class User {
  final String uuid;
  final String firstname;
  final String lastname;
  final String email;
  final UserRole role;
  final String password;

  User({ required this.uuid, required this.firstname, required this.lastname, required this.email, required this.role, required this.password });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uuid: json['uuid'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      email: json['email'],
      password: json['password'],
      role: UserRole.values.firstWhere((e) => e.value == json['role']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'password': password,
      'role': role.value,
    };
  }

}