import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/domain/model/category.dart';
import 'package:dartz/dartz.dart';

abstract class CategoryRepository {
  Future<Either<Failure, List<Category>>> getCategories({String? channelId});
  Future<Either<Failure, Category>> getCategory(int id);
}
