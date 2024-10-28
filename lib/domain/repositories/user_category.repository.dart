import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/entity/user_subscription.entity.dart';
import 'package:zippy/data/sources/user_subscription.source.dart';
import 'package:zippy/domain/model/user_subscription.model.dart';
import 'package:dartz/dartz.dart';

abstract class UserSubscriptionRepository {
  Future<Either<Failure, List<UserSubscription>>> getUserSubscriptions();
  Future<Either<Failure, List<UserSubscription>>> createUserSubscriptions(
      List<UserSubscriptionEntity> subscriptions);
  Future<Either<Failure, List<UserSubscription>>> deleteUserSubscriptions(
      List<UserSubscriptionEntity> subscriptions);
  Future<Either<Failure, bool>> resetAllUserSubscriptions();
  Stream<List<UserSubscription>> subscribeUserSubscriptions();
}

class UserSubscriptionRepositoryImpl implements UserSubscriptionRepository {
  final UserSubscriptionDatasource datasource;

  UserSubscriptionRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<UserSubscription>>> createUserSubscriptions(
      List<UserSubscriptionEntity> subscriptions) {
    return datasource.createUserSubscriptions(subscriptions);
  }

  @override
  Future<Either<Failure, List<UserSubscription>>> deleteUserSubscriptions(
      List<UserSubscriptionEntity> subscriptions) {
    return datasource.deleteUserSubscriptions(subscriptions);
  }

  @override
  Future<Either<Failure, bool>> resetAllUserSubscriptions() {
    return datasource.resetAllUserSubscriptions();
  }

  @override
  Future<Either<Failure, List<UserSubscription>>> getUserSubscriptions() {
    return datasource.getUserSubscriptions();
  }

  @override
  Stream<List<UserSubscription>> subscribeUserSubscriptions() {
    return datasource.subscribeUserSubscriptions();
  }
}
