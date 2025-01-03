import 'package:get/get.dart';
import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/domain/model/source.model.dart';
import 'package:dartz/dartz.dart';
import 'package:zippy/domain/repositories/source.repository.dart';

class GetSources {
  final SourceRepository repo = Get.find();

  Future<Either<Failure, List<Source>>> execute({bool withJoin = false}) {
    return repo.getSources(withJoin: withJoin);
  }
}
