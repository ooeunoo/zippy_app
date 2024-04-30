import 'package:zippy/app/failures/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:zippy/data/sources/interfaces/user_category_data_source.dart';
import 'package:zippy/domain/model/user_category.dart';

class GetUserCategory {
  final UserCategoryDatasource repo;

  GetUserCategory(this.repo);

  Future<Either<Failure, List<UserCategory>>> execute() {
    return repo.getUserCategories();
  }
}
