import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/entity/user_category_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:zippy/domain/model/user_category.dart';

abstract class UserCategoryRepository {
  Future<Either<Failure, List<UserCategory>>> getUserCategories();
  Future<Either<Failure, List<UserCategory>>> createUserCategory(
      List<UserCategoryEntity> categories);
  Future<Either<Failure, List<UserCategory>>> deleteUserCategory(
      List<UserCategoryEntity> categories);
  Stream<List<UserCategory>> subscribeUserCategories();
}
