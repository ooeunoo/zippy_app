import 'package:cocomu/app/failures/failure.dart';
import 'package:cocomu/data/sources/interfaces/category_data_source.dart';
import 'package:cocomu/domain/model/category.dart';
import 'package:cocomu/domain/repositories/interfaces/category_repository.dart';
import 'package:dartz/dartz.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryDatasource datasource;

  CategoryRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<Category>>> getCategories() {
    return datasource.getCategories();
  }

  @override
  Future<Either<Failure, Category>> getCategory(int id) {
    return datasource.getCategory(id);
  }
}
