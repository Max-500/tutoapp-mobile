import 'package:intl/intl.dart';

class TutoredPermissionModel {
  final String userUUID;
  final String studentUUID;
  final String tutorUserUUID;
  final String fecha;
  final String fullname;
  final String matricula;

  TutoredPermissionModel({required this.userUUID, required this.studentUUID, required this.tutorUserUUID, required this.fecha, required this.fullname, required this.matricula});

  factory TutoredPermissionModel.fromJson(Map<String, dynamic> json) {
    DateTime parsedDate = DateTime.parse(json['fecha']);
    String formattedDate = DateFormat('dd MMM yyyy, HH:mm').format(parsedDate);

    return TutoredPermissionModel(userUUID: json['uuid'], studentUUID: json['studentUUID'], tutorUserUUID: json['tutorUUID'], fecha: formattedDate, fullname: json['fullName'], matricula: json['matricula']);
  }
}