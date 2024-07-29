import 'package:image_picker/image_picker.dart';
import 'package:tuto_app/features/tutor/data/models/tutored_model.dart';
import 'package:tuto_app/features/tutor/data/models/tutored_permission_model.dart';

abstract class TutorDatasource {
  Future<String> getCode(String userUUID);
  Future<void> becomePremium(String userUUID, String transactionId);
  Future<List<TutoredModel>> getTutoreds(String userUUID);
  Future<dynamic> getOrder();
  Future<dynamic> cancelOrder(String transactionId);
  Future<bool> isPremium(String userUUID);
  Future<String> updateSchedule(String userUUID, XFile file);
  Future<List<TutoredPermissionModel>> getTutoredsPermissions(String userUUID);
}