import 'package:zippy/domain/model/user_subscription.model.dart';
import 'package:zippy/domain/repositories/user_category.repository.dart';

class GetUserSubscriptionsStream {
  final UserSubscriptionRepository repo;

  GetUserSubscriptionsStream(this.repo);

  Stream<List<UserSubscription>> execute(String userId) {
    return repo.getUserSubscriptionsStream(userId);
  }
}
