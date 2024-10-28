import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/sources/platform.source.dart';
import 'package:zippy/domain/model/platform.model.dart';
import 'package:dartz/dartz.dart';

abstract class PlatformRepository {
  Future<Either<Failure, List<Platform>>> getPlatforms(
      {bool withSources = false});
  Future<Either<Failure, Platform>> getPlatform(int id);
}

class PlatformRepositoryImpl implements PlatformRepository {
  final PlatformDatasource datasource;

  PlatformRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<Platform>>> getPlatforms({
    bool withSources = false,
  }) {
    return datasource.getPlatforms(withSources: withSources);
  }

  @override
  Future<Either<Failure, Platform>> getPlatform(int id) {
    return datasource.getPlatform(id);
  }
}
