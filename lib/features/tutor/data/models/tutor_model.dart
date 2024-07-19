import 'package:tuto_app/features/auth/data/models/user_model.dart';
import 'package:tuto_app/features/tutor/domain/entities/tutor.dart';

class TutorModel extends Tutor {

  TutorModel({required super.user, required super.code, required super.horario, required super.filename});

  factory TutorModel.fromJson(Map<String, dynamic> json) {
    return TutorModel(
      user: UserModel.fromJSON(json['user']),
      code: json['code'],
      horario: json['horario'],
      filename: json['filename'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'user': (user as UserModel).toJson(),
      'code': code,
      'horario': horario,
      'filename': filename,
    };
  }

}