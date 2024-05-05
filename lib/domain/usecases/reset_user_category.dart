import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/entity/user_category_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:zippy/domain/model/user_category.dart';
import 'package:zippy/domain/repositories/interfaces/user_category_repository.dart';

class ResetUserCategory {
  final UserCategoryRepository repo;

  ResetUserCategory(this.repo);

  Future<Either<Failure, bool>> execute() {
    return repo.resetAllUserCategory();
  }
}
