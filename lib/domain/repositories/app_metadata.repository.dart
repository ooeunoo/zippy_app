import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/sources/app_metadata.source.dart';
import 'package:dartz/dartz.dart';
import 'package:zippy/domain/model/params/update_app_metadata.params.dart';
import 'package:zippy/domain/model/app_metadata.model.dart';

abstract class AppMetadataRepository {
  Future<Either<Failure, AppMetadata?>> getAppMetadata();
  Future<Either<Failure, Unit>> updateAppMetadata(UpdateAppMetadataParams params);
  Future<Either<Failure, Unit>> saveAppMetadata(AppMetadata metadata);
  Future<Either<Failure, Unit>> clearAppMetadata();
}

class AppMetadataRepositoryImpl implements AppMetadataRepository {
  final AppMetadataDataSource datasource;

  AppMetadataRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, AppMetadata?>> getAppMetadata() {
    return datasource.getAppMetadata();
  }

  @override
  Future<Either<Failure, Unit>> updateAppMetadata(
      UpdateAppMetadataParams params) {
    return datasource.updateAppMetadata(params);
  }

  @override
  Future<Either<Failure, Unit>> clearAppMetadata() {
    return datasource.clearAppMetadata();
  }

  @override
  Future<Either<Failure, Unit>> saveAppMetadata(AppMetadata metadata) {
    return datasource.saveAppMetadata(metadata);
  }
}
