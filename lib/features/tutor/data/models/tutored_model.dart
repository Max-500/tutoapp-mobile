class TutoredModel {
  final String userUUID;
  final String fullname;
  final String matricula;
  final String gradeAndGroup;
  final String phoneNumer;
  final String homePhone;
  final String nss;
  final String profileImage;

  TutoredModel({required this.userUUID, required this.fullname, required this.matricula, required this.gradeAndGroup, required this.phoneNumer, required this.homePhone, required this.nss, required this.profileImage});

  factory TutoredModel.fromJson(Map<String, dynamic> json) {
    return TutoredModel(userUUID: json['uuid'], fullname: json['fullname'], matricula: json['matricula'], gradeAndGroup: json['gradeAndGroup'], phoneNumer: json['phoneNumber'], homePhone: json['homePhone'], nss: json['nss'], profileImage: json['profileImage']);
  }
}