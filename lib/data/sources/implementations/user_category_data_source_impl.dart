// ignore_for_file: non_constant_identifier_names

import 'package:hive/hive.dart';
import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/entity/user_category_entity.dart';
import 'package:zippy/data/providers/hive_provider.dart';
import 'package:zippy/data/sources/interfaces/user_category_data_source.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:zippy/domain/model/user_category.dart';

enum UserCategoryKey {
  all('전체보기'),
  ;

  const UserCategoryKey(this.name);
  final String name;
}

class UserCategoryDatasourceImpl implements UserCategoryDatasource {
  final box = Get.find<HiveProvider>().userCategories!;

  @override
  Future<Either<Failure, List<UserCategory>>> createUserCategory(
      List<UserCategoryEntity> newCategories) async {
    try {
      List<dynamic> categories = _getCategories();

      categories.addAll(newCategories);

      await box.put(UserCategoryKey.all.name, categories);

      return Right(toCategoryModelAll());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<UserCategory>>> deleteUserCategory(
      List<UserCategoryEntity> removeCategories) async {
    try {
      List<dynamic> categories = _getCategories();
      categories.removeWhere(
          (category) => removeCategories.any((rc) => rc.id == category.id));

      await box.put(UserCategoryKey.all.name, categories);

      return Right(toCategoryModelAll());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> resetAllUserCategory() async {
    try {
      await box.put(UserCategoryKey.all.name, []);
      return const Right(true);
    } catch (e) {
      print(e);
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<UserCategory>>> getUserCategories() async {
    try {
      return Right(toCategoryModelAll());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Stream<List<UserCategory>> subscribeUserCategories() {
    return box.watch().map((event) {
      return toCategoryModelAll();
    });
  }

  List<dynamic> _getCategories() {
    return box.get(UserCategoryKey.all.name, defaultValue: []);
  }

  List<UserCategory> toCategoryModelAll() {
    return _getCategories()
        .map((category) => UserCategory(
              id: category.id,
              channelId: category.channelId,
              name: category.name,
            ))
        .toList();
  }
}
