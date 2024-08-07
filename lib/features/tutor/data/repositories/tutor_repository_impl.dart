import 'package:tuto_app/config/shared_preferences/tutor/shared_preferences_services_tutor.dart';
import 'package:tuto_app/features/tutor/data/datasources/tutor_remote_data_source.dart';
import 'package:tuto_app/features/tutor/data/models/tutored_model.dart';
import 'package:tuto_app/features/tutor/data/models/tutored_permission_model.dart';
import 'package:tuto_app/features/tutor/domain/repositories/tutor_repository.dart';
import 'package:image_picker/image_picker.dart';

class TutorRepositoryImpl implements TutorRepository {
  final TutorRemoteDataSourceImpl remoteDataSource;

  TutorRepositoryImpl({required this.remoteDataSource});

  @override
  Future<String> getCode(String userUUID) async {
    return await remoteDataSource.getCode(userUUID);
  }
  
  @override
  Future<void> getPremium(String transactionId) async {
    final student = await SharedPreferencesServiceTutor.getUser();
    await remoteDataSource.becomePremium(student['uuid'], transactionId);
  }

  @override
  Future<List<TutoredModel>> getTutoreds(String userUUID) async {
    return remoteDataSource.getTutoreds(userUUID);
  }
  
  @override
  Future cancelOrder(String transactionId) async {
    await remoteDataSource.cancelOrder(transactionId);
  }
  
  @override
  Future getOrder() async {
    return await remoteDataSource.getOrder();
  }
  
  @override
  Future<bool> isPremium() async {
    final tutor = await SharedPreferencesServiceTutor.getUser();
    return await remoteDataSource.isPremium(tutor['uuid']);
  }

  @override
  Future<String> updateSchedule(String userUUID, XFile file) async {
    return await remoteDataSource.updateSchedule(userUUID, file);
  }

  @override
  Future<List<TutoredPermissionModel>> getTutoredsPermissions(String userUUID) async {
    return await remoteDataSource.getTutoredsPermissions(userUUID);
  }
  
  @override
  Future getPDF(String matricula, String nombre, String grado, String grupo, String phone, String telephone, String nss) async {
    await remoteDataSource.getPDF(matricula, nombre, grado, grupo, phone, telephone, nss);
  }
}