import 'package:get/get.dart';
import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/domain/model/content_type.model.dart';
import 'package:dartz/dartz.dart';
import 'package:zippy/domain/repositories/content_type.repository.dart';

class GetContentTypes {
  final ContentTypeRepository repo = Get.find();

  Future<Either<Failure, List<ContentType>>> execute() {
    return repo.getContentTypes();
  }
}
