import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/sources/interfaces/category_data_source.dart';
import 'package:zippy/domain/model/category.dart';
import 'package:zippy/domain/repositories/interfaces/category_repository.dart';
import 'package:dartz/dartz.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryDatasource datasource;

  CategoryRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<Category>>> getCategories({String? channelId}) {
    return datasource.getCategories(channelId: channelId);
  }

  @override
  Future<Either<Failure, Category>> getCategory(int id) {
    return datasource.getCategory(id);
  }
}
