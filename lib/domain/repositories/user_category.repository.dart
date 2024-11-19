import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/sources/user_subscription.source.dart';
import 'package:zippy/domain/model/params/create_or_delete_user_subscription.params.dart';
import 'package:zippy/domain/model/user_subscription.model.dart';
import 'package:dartz/dartz.dart';

abstract class UserSubscriptionRepository {
  Future<Either<Failure, List<UserSubscription>>> getUserSubscriptions(
      String userId);
  Future<Either<Failure, bool>> createUserSubscriptions(
      CreateOrDeleteUserSubscriptionParams subscriptions);
  Future<Either<Failure, bool>> deleteUserSubscriptions(
      CreateOrDeleteUserSubscriptionParams subscriptions);
  RealtimeChannel listenUserSubscriptionChanges(
      String userId, void Function() callback);
}

class UserSubscriptionRepositoryImpl implements UserSubscriptionRepository {
  final UserSubscriptionDatasource datasource;

  UserSubscriptionRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, bool>> createUserSubscriptions(
      CreateOrDeleteUserSubscriptionParams subscriptions) {
    return datasource.createUserSubscriptions(subscriptions);
  }

  @override
  Future<Either<Failure, bool>> deleteUserSubscriptions(
      CreateOrDeleteUserSubscriptionParams subscriptions) {
    return datasource.deleteUserSubscriptions(subscriptions);
  }

  @override
  Future<Either<Failure, List<UserSubscription>>> getUserSubscriptions(
      String userId) {
    return datasource.getUserSubscriptions(userId);
  }

  @override
  RealtimeChannel listenUserSubscriptionChanges(
      String userId, void Function() callback) {
    return datasource.listenUserSubscriptionChanges(userId, callback);
  }
}
