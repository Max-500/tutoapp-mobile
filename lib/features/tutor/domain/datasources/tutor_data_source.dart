import 'package:flutter/material.dart';
import 'package:tuto_app/features/tutor/data/models/tutored_model.dart';

abstract class TutorDatasource {
  Future<String> getCode(String userUUID);
  Future<void> getPremium(BuildContext context);
  Future<List<TutoredModel>> getTutoreds(String userUUID);
}