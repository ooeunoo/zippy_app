import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/entity/user_category_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:zippy/domain/model/user_category.dart';
import 'package:zippy/domain/repositories/interfaces/user_category_repository.dart';

class DeleteUserCategory {
  final UserCategoryRepository repo;

  DeleteUserCategory(this.repo);

  Future<Either<Failure, List<UserCategory>>> execute(
      List<UserCategoryEntity> categories) {
    return repo.deleteUserCategory(categories);
  }
}
