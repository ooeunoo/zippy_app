import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/entity/category_entity.dart';
import 'package:zippy/domain/model/category.dart';
import "package:dartz/dartz.dart";

abstract class CategoryDatasource {
  Future<Either<Failure, List<Category>>> getCategories();
  Future<Either<Failure, Category>> getCategory(int id);
}
