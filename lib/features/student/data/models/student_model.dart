import 'package:tuto_app/features/student/domain/entities/student.dart';

class StudentModel extends Student {

  StudentModel({
    required super.user,
    required super.userUUIDTutor,
    required super.haveTutor,
    required super.generalData,
    required super.typeLearning,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      user: json['user'],
      userUUIDTutor: json['userUUIDTutor'],
      haveTutor: json['haveTutor'],
      generalData: json['generalData'],
      typeLearning: json['typeLearning'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user,
      'userUUIDTutor': userUUIDTutor,
      'haveTutor': haveTutor,
      'generalData': generalData,
      'typeLearning': typeLearning,
    };
  }
}
