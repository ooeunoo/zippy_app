import 'package:zippy/domain/model/user_subscription.model.dart';
import 'package:zippy/domain/repositories/user_category.repository.dart';

class SubscribeUserSubscriptions {
  final UserSubscriptionRepository repo;

  SubscribeUserSubscriptions(this.repo);

  Stream<List<UserSubscription>> execute(String userId) {
    return repo.subscribeUserSubscriptions(userId);
  }
}
