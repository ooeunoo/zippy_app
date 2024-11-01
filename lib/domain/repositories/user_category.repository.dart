import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/sources/user_subscription.source.dart';
import 'package:zippy/domain/model/params/create_user_subscription.params.dart';
import 'package:zippy/domain/model/user_subscription.model.dart';
import 'package:dartz/dartz.dart';

abstract class UserSubscriptionRepository {
  Future<Either<Failure, List<UserSubscription>>> getUserSubscriptions();
  Future<Either<Failure, bool>> createUserSubscriptions(
      CreateUserSubscriptionParams subscriptions);
  Future<Either<Failure, bool>> deleteUserSubscriptions(int subscriptionId);
  Stream<List<UserSubscription>> subscribeUserSubscriptions(String userId);
}

class UserSubscriptionRepositoryImpl implements UserSubscriptionRepository {
  final UserSubscriptionDatasource datasource;

  UserSubscriptionRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, bool>> createUserSubscriptions(
      CreateUserSubscriptionParams subscriptions) {
    return datasource.createUserSubscriptions(subscriptions);
  }

  @override
  Future<Either<Failure, bool>> deleteUserSubscriptions(int subscriptionId) {
    return datasource.deleteUserSubscriptions(subscriptionId);
  }

  @override
  Future<Either<Failure, List<UserSubscription>>> getUserSubscriptions() {
    return datasource.getUserSubscriptions();
  }

  @override
  Stream<List<UserSubscription>> subscribeUserSubscriptions(String userId) {
    return datasource.subscribeUserSubscriptions(userId);
  }
}
