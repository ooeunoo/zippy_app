import 'package:zippy/app/failures/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:zippy/domain/model/source.model.dart';
import 'package:zippy/data/sources/source.source.dart';

abstract class SourceRepository {
  Future<Either<Failure, List<Source>>> getSources({String? channelId});
  Future<Either<Failure, Source>> getSource(int id);
}

class SourceRepositoryImpl implements SourceRepository {
  final SourceDatasource datasource;

  SourceRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<Source>>> getSources({String? channelId}) {
    return datasource.getSources(channelId: channelId);
  }

  @override
  Future<Either<Failure, Source>> getSource(int id) {
    return datasource.getSource(id);
  }
}
