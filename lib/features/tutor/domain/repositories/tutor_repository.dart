import 'package:image_picker/image_picker.dart';
import 'package:tuto_app/features/tutor/data/models/tutored_model.dart';

abstract class TutorRepository {
  Future<String> getCode(String userUUID);
  Future<void> getPremium(String transactionId);
  Future<List<TutoredModel>> getTutoreds(String userUUID);
  Future<dynamic> getOrder();
  Future<dynamic> cancelOrder(String transactionId);
  Future<bool> isPremium();
  Future<String> updateSchedule(String userUUID, XFile file);
}