import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/domain/model/category.dart';
import 'package:zippy/domain/repositories/interfaces/category_repository.dart';
import 'package:dartz/dartz.dart';

class GetCategories {
  final CategoryRepository repo;

  GetCategories(this.repo);

  Future<Either<Failure, List<Category>>> execute() {
    return repo.getCategories();
  }
}
