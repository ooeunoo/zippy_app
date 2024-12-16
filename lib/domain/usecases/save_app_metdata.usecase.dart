import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/domain/model/app_metadata.model.dart';
import 'package:zippy/domain/repositories/app_metadata.repository.dart';
import 'package:dartz/dartz.dart';

class SaveAppMetadata {
  final AppMetadataRepository repo;

  SaveAppMetadata(this.repo);

  Future<Either<Failure, Unit>> execute(AppMetadata metadata) {
    return repo.saveAppMetadata(metadata);
  }
}
