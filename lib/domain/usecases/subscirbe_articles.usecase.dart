import 'package:zippy/domain/model/article.model.dart';
import 'package:zippy/domain/model/user_subscription.model.dart';
import 'package:zippy/domain/repositories/article.repository.dart';

class SubscribeArticles {
  final ArticleRepository repo;

  SubscribeArticles(this.repo);

  Stream<List<Article>> execute(List<UserSubscription> subscriptions) {
    return repo.subscribeArticles(subscriptions);
  }
}
