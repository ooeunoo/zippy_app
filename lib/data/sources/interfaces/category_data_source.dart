import 'package:cocomu/app/failures/failure.dart';
import 'package:cocomu/data/entity/category_entity.dart';
import 'package:cocomu/domain/model/category.dart';
import "package:dartz/dartz.dart";

abstract class CategoryDatasource {
  Future<Either<Failure, List<Category>>> getCategories();
  Future<Either<Failure, Category>> getCategory(int id);
}
