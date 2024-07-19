import 'package:tuto_app/features/auth/domain/entities/user.dart';

class Tutor {
  final User user;
  final String code;
  final String horario;
  final String filename;

  Tutor({
    required this.user,
    required this.code,
    required this.horario,
    required this.filename,
  });

  factory Tutor.fromJson(Map<String, dynamic> json) {
    return Tutor(
      user: User.fromJson(json['user']),
      code: json['code'],
      horario: json['horario'],
      filename: json['filename'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'code': code,
      'horario': horario,
      'filename': filename,
    };
  }

}