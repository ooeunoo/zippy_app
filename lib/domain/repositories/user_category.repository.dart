import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/sources/user_subscription.source.dart';
import 'package:zippy/domain/model/params/create_or_delete_user_subscription.params.dart';
import 'package:zippy/domain/model/user_subscription.model.dart';
import 'package:dartz/dartz.dart';

abstract class UserSubscriptionRepository {
  Future<Either<Failure, List<UserSubscription>>> getUserSubscriptions(
      String userId);
  Future<Either<Failure, bool>> toggleUserSubscription(
      CreateOrDeleteUserSubscriptionParams subscriptions);
  Stream<List<UserSubscription>> getUserSubscriptionsStream(String userId);
}

class UserSubscriptionRepositoryImpl implements UserSubscriptionRepository {
  final UserSubscriptionDatasource datasource;

  UserSubscriptionRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, bool>> toggleUserSubscription(
      CreateOrDeleteUserSubscriptionParams subscriptions) {
    return datasource.toggleUserSubscription(subscriptions);
  }

  @override
  Future<Either<Failure, List<UserSubscription>>> getUserSubscriptions(
      String userId) {
    return datasource.getUserSubscriptions(userId);
  }

  @override
  Stream<List<UserSubscription>> getUserSubscriptionsStream(String userId) {
    return datasource.getUserSubscriptionsStream(userId);
  }
}
