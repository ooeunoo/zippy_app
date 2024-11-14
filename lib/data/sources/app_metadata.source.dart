import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/entity/app_metadata.entity.dart';
import 'package:zippy/data/providers/hive.provider.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:zippy/domain/model/app_metadata.model.dart';
import 'package:zippy/domain/model/params/update_app_metadata.params.dart';

abstract class AppMetadataDatasource {
  Future<Either<Failure, AppMetadata>> getAppMetadata();
  Future<Either<Failure, AppMetadata>> updateAppMetadata(
      UpdateAppMetadataParams params);
}

class AppMetadataDatasourceImpl implements AppMetadataDatasource {
  final box = Get.find<HiveProvider>().appMetadata!;

  AppMetadataEntity _getOrCreateEntity() {
    if (box.isEmpty) {
      final newEntity = AppMetadataEntity(lookaround: false);
      box.add(newEntity); // 키 없이 저장
      return newEntity;
    }
    return box.getAt(0) as AppMetadataEntity; // 첫 번째(유일한) 엔티티 반환
  }

  @override
  Future<Either<Failure, AppMetadata>> getAppMetadata() async {
    try {
      final entity = _getOrCreateEntity();
      return Right(entity.toModel());
    } catch (e, stackTrace) {
      print('Caught an exception: $e');
      print('Stack Trace: $stackTrace');
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, AppMetadata>> updateAppMetadata(
      UpdateAppMetadataParams params) async {
    try {
      final entity = _getOrCreateEntity();

      final updates = params.toJson();
      updates.forEach((key, value) {
        switch (key) {
          case 'lookaround':
            entity.lookaround = value as bool;
            break;
        }
      });

      await entity.save();
      return Right(entity.toModel());
    } catch (e, stackTrace) {
      print('Caught an exception: $e');
      print('Stack Trace: $stackTrace');
      return Left(CacheFailure());
    }
  }
}
