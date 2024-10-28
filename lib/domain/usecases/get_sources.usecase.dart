import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/domain/model/source.model.dart';
import 'package:dartz/dartz.dart';
import 'package:zippy/domain/repositories/source.repository.dart';

class GetSources {
  final SourceRepository repo;

  GetSources(this.repo);

  Future<Either<Failure, List<Source>>> execute({String? channelId}) {
    return repo.getSources(channelId: channelId);
  }
}
