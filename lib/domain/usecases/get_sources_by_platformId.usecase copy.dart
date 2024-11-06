import 'package:get/get.dart';
import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/domain/model/source.model.dart';
import 'package:dartz/dartz.dart';
import 'package:zippy/domain/repositories/source.repository.dart';

class GetSourcesByPlatformId {
  final SourceRepository repo = Get.find();

  Future<Either<Failure, List<Source>>> execute({String? platformId}) {
    return repo.getSourcesByPlatformId(platformId: platformId);
  }
}
