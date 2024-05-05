import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/entity/user_category_entity.dart';
import 'package:zippy/data/sources/interfaces/user_category_data_source.dart';
import 'package:zippy/domain/model/user_category.dart';
import 'package:dartz/dartz.dart';
import 'package:zippy/domain/repositories/interfaces/user_category_repository.dart';

class UserCategoryRepositoryImpl implements UserCategoryRepository {
  final UserCategoryDatasource datasource;

  UserCategoryRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<UserCategory>>> createUserCategory(
      List<UserCategoryEntity> categories) {
    return datasource.createUserCategory(categories);
  }

  @override
  Future<Either<Failure, List<UserCategory>>> deleteUserCategory(
      List<UserCategoryEntity> categories) {
    return datasource.deleteUserCategory(categories);
  }

  @override
  Future<Either<Failure, bool>> resetAllUserCategory() {
    return datasource.resetAllUserCategory();
  }

  @override
  Future<Either<Failure, List<UserCategory>>> getUserCategories() {
    return datasource.getUserCategories();
  }

  @override
  Stream<List<UserCategory>> subscribeUserCategories() {
    return datasource.subscribeUserCategories();
  }
}
