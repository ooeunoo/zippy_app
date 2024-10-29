import 'package:zippy/data/sources/user_subscription.source.dart';

abstract class UserSubscriptionRepository {}

class UserSubscriptionRepositoryImpl implements UserSubscriptionRepository {
  final UserSubscriptionDatasource datasource;

  UserSubscriptionRepositoryImpl(this.datasource);
}
