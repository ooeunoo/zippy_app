import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/sources/app_metadata.source.dart';
import 'package:dartz/dartz.dart';
import 'package:zippy/domain/model/params/update_app_metadata.params.dart';
import 'package:zippy/domain/model/app_metadata.model.dart';

abstract class AppMetadataRepository {
  Future<Either<Failure, AppMetadata>> getAppMetadata();
  Future<Either<Failure, AppMetadata>> updateAppMetadata(
      UpdateAppMetadataParams params);
}

class AppMetadataRepositoryImpl implements AppMetadataRepository {
  final AppMetadataDatasource datasource;

  AppMetadataRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, AppMetadata>> getAppMetadata() {
    return datasource.getAppMetadata();
  }

  @override
  Future<Either<Failure, AppMetadata>> updateAppMetadata(
      UpdateAppMetadataParams params) {
    return datasource.updateAppMetadata(params);
  }
}
