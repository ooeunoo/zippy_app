import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/sources/article.source.dart';
import 'package:zippy/domain/model/article.model.dart';
import 'package:zippy/domain/model/params/get_aritlces_params.dart';
import 'package:zippy/domain/model/user_subscription.model.dart';
import 'package:dartz/dartz.dart';

abstract class ArticleRepository {
  Future<Either<Failure, List<Article>>> getArticles(GetArticlesParams params);
  Future<Either<Failure, Article>> getArticle(int id);
  Stream<List<Article>> subscribeArticles(List<UserSubscription> subscriptions);
  Future<void> upArticleViewCount(int id);
  Future<void> upArticleReportCount(int id);
}

class ArticleRepositoryImpl implements ArticleRepository {
  final ArticleDatasource datasource;

  ArticleRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<Article>>> getArticles(GetArticlesParams params) {
    return datasource.getArticles(params);
  }

  @override
  Future<Either<Failure, Article>> getArticle(int id) {
    return datasource.getArticle(id);
  }

  @override
  Stream<List<Article>> subscribeArticles(
      List<UserSubscription> subscriptions) {
    return datasource.subscribeArticles(subscriptions);
  }

  @override
  Future<void> upArticleViewCount(int id) {
    return datasource.upArticleViewCount(id);
  }

  @override
  Future<void> upArticleReportCount(int id) {
    return datasource.upArticleReportCount(id);
  }
}
