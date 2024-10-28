import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/domain/model/platform.model.dart';
import 'package:dartz/dartz.dart';
import 'package:zippy/domain/repositories/platform.repository.dart';

class GetPlatforms {
  final PlatformRepository repo;

  GetPlatforms(this.repo);

  Future<Either<Failure, List<Platform>>> execute({
    bool withSources = false,
  }) {
    return repo.getPlatforms(withSources: withSources);
  }
}
