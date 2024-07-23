import 'package:flutter/material.dart';

abstract class TutorDatasource {
  Future<String> getCode(String userUUID);
  Future<void> getPremium(BuildContext context);
}