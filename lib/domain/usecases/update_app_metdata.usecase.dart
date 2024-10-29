import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/domain/model/app_metadata.model.dart';
import 'package:zippy/domain/model/params/update_app_metadata.params.dart';
import 'package:zippy/domain/repositories/app_metadata.repository.dart';
import 'package:dartz/dartz.dart';

class UpdateAppMetadata {
  final AppMetadataRepository repo;

  UpdateAppMetadata(this.repo);

  Future<Either<Failure, AppMetadata>> execute(UpdateAppMetadataParams params) {
    return repo.updateAppMetadata(params);
  }
}
