import 'package:flutter/material.dart';

abstract class TutorRepository {
  Future<String> getCode(String userUUID);
  Future<void> getPremium(BuildContext context);
}