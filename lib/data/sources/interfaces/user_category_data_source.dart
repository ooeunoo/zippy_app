import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/entity/user_category_entity.dart';
import "package:dartz/dartz.dart";
import 'package:zippy/domain/model/user_category.dart';

abstract class UserCategoryDatasource {
  Future<Either<Failure, List<UserCategory>>> createUserCategory(
      List<UserCategoryEntity> categories);
  Future<Either<Failure, List<UserCategory>>> deleteUserCategory(
      List<UserCategoryEntity> categories);
  Future<Either<Failure, bool>> resetAllUserCategory();
  Future<Either<Failure, List<UserCategory>>> getUserCategories();
  Stream<List<UserCategory>> subscribeUserCategories();
}
