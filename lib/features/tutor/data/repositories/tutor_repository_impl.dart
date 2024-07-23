import 'package:flutter/material.dart';
import 'package:tuto_app/features/tutor/data/datasources/tutor_remote_data_source.dart';
import 'package:tuto_app/features/tutor/domain/repositories/tutor_repository.dart';

class TutorRepositoryImpl implements TutorRepository{
  final TutorRemoteDataSourceImpl remoteDataSource;

  TutorRepositoryImpl({required this.remoteDataSource});

  @override
  Future<String> getCode(String userUUID) async {
    return await remoteDataSource.getCode(userUUID);
  }
  
  @override
  Future<void> getPremium(BuildContext context) async {
    await remoteDataSource.getPremium(context);
  }

}