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
  static const String APP_METADATA_KEY = 'app_metadata_key';

  AppMetadataEntity _getOrCreateEntity() {
    if (!box.containsKey(APP_METADATA_KEY)) {
      final newEntity = AppMetadataEntity(
        lookaround: false,
        themeMode: 'system',
        onBoardingBoardPage: false,
        onBoardingBookmarkPage: false,
      );
      box.put(APP_METADATA_KEY, newEntity);
      return newEntity;
    }
    return box.get(APP_METADATA_KEY) as AppMetadataEntity;
  }

  @override
  Future<Either<Failure, AppMetadata>> getAppMetadata() async {
    try {
      final entity = _getOrCreateEntity();
      print('[Get] Current AppMetadata: ${entity.toJson()}');
      return Right(entity.toModel());
    } catch (e, stackTrace) {
      print('Error:$e \n stackTrace:$stackTrace');
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, AppMetadata>> updateAppMetadata(
      UpdateAppMetadataParams params) async {
    try {
      final entity = _getOrCreateEntity();
      print('[Update] Before: ${entity.toJson()}');

      final updates = params.toJson();
      updates.forEach((key, value) {
        switch (key) {
          case 'lookaround':
            entity.lookaround = value as bool;
            break;
          case 'themeMode':
            entity.themeMode = value as String;
            break;
          case 'onBoardingBoardPage':
            entity.onBoardingBoardPage = value as bool;
            break;
          case 'onBoardingBookmarkPage':
            entity.onBoardingBookmarkPage = value as bool;
            break;
        }
      });

      await box.put(APP_METADATA_KEY, entity);

      // 업데이트 후 즉시 확인
      final updatedEntity = box.get(APP_METADATA_KEY) as AppMetadataEntity;
      print('[Update] After: ${updatedEntity.toJson()}');

      return Right(updatedEntity.toModel());
    } catch (e, stackTrace) {
      print('Error:$e \n stackTrace:$stackTrace');
      return Left(CacheFailure());
    }
  }
}
