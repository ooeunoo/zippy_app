import 'package:zippy/app/failures/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:zippy/domain/model/source.model.dart';
import 'package:zippy/data/sources/source.source.dart';

abstract class SourceRepository {
  Future<Either<Failure, List<Source>>> getSources({bool withJoin = false});
  Future<Either<Failure, List<Source>>> getSourcesByPlatformId(
      {String? platformId});
  Future<Either<Failure, Source>> getSource(int id);
}

class SourceRepositoryImpl implements SourceRepository {
  final SourceDatasource datasource;

  SourceRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<Source>>> getSources({bool withJoin = false}) {
    return datasource.getSources(withJoin: withJoin);
  }

  @override
  Future<Either<Failure, List<Source>>> getSourcesByPlatformId(
      {String? platformId}) {
    return datasource.getSourcesByPlatformId(platformId: platformId);
  }

  @override
  Future<Either<Failure, Source>> getSource(int id) {
    return datasource.getSource(id);
  }
}
