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