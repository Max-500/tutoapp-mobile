import 'package:tuto_app/features/student/data/datasources/student_remote_data_source_impl.dart';
import 'package:tuto_app/features/student/domain/repositories/student_repository.dart';

class StudentRepositoryImpl implements StudentRepository {
  final StudentRemoteDataSourceImpl remoteDataSource;

  StudentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> saveDataGeneral(String userUUID, String matricula, String group, String quarter, String phoneNumer, String homePhone, String nss) async {
    await remoteDataSource.saveDataGeneral(userUUID, matricula, group, quarter, phoneNumer, homePhone, nss);
  }

  @override
  Future<void> saveTypeLearning(String userUUID, List<String> typeLearning) async {
    await remoteDataSource.saveTypeLearning(userUUID, typeLearning);
  }

  @override
  Future<String> vinculeTutor(String userUUID, String code) async {
    return await remoteDataSource.vinculeTutor(userUUID, code);
  }
  
  @override
  Future<String> getScheduleTutor(String tutorUUID) async {
    return await remoteDataSource.getScheduleTutor(tutorUUID);
  }

}