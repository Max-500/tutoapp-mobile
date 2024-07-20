import 'package:tuto_app/features/auth/domain/entities/user.dart';

class Student {
  final User user;
  final String userUUIDTutor;
  final bool haveTutor;
  final bool generalData;
  final bool typeLearning;

  Student({
    required this.user,
    required this.userUUIDTutor,
    required this.haveTutor,
    required this.generalData,
    required this.typeLearning,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_uuid': user,
      'user_uuid_tutor': userUUIDTutor,
      'have_tutor': haveTutor,
      'general_data': generalData,
      'type_learning': typeLearning,
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      user: map['user_uuid'],
      userUUIDTutor: map['user_uuid_tutor'],
      haveTutor: map['have_tutor'],
      generalData: map['general_data'],
      typeLearning: map['type_learning'],
    );
  }
}
