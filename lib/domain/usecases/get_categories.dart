import 'package:cocomu/app/failures/failure.dart';
import 'package:cocomu/domain/model/category.dart';
import 'package:cocomu/domain/repositories/interfaces/category_repository.dart';
import 'package:dartz/dartz.dart';

class GetCategories {
  final CategoryRepository repo;

  GetCategories(this.repo);

  Future<Either<Failure, List<Category>>> execute() {
    return repo.getCategories();
  }
}
