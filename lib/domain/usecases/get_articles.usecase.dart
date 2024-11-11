import 'package:get/get.dart';
import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/domain/model/article.model.dart';
import 'package:zippy/domain/model/params/get_aritlces.params.dart';
import 'package:dartz/dartz.dart';
import 'package:zippy/domain/repositories/article.repository.dart';

class GetArticles {
  final ArticleRepository repo = Get.find();

  Future<Either<Failure, List<Article>>> execute(GetArticlesParams params) {
    return repo.getArticles(params);
  }
}
