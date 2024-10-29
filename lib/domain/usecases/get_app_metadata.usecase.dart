import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/domain/model/app_metadata.model.dart';
import 'package:zippy/domain/repositories/app_metadata.repository.dart';
import 'package:dartz/dartz.dart';

class GetAppMetadata {
  final AppMetadataRepository repo;

  GetAppMetadata(this.repo);

  Future<Either<Failure, AppMetadata>> execute() {
    return repo.getAppMetadata();
  }
}
