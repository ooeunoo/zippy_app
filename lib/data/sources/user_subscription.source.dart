import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/entity/user_subscription.entity.dart';
import 'package:zippy/data/providers/hive.provider.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:zippy/domain/model/user_subscription.model.dart';

enum UserSubscriptionsKey {
  all('전체보기'),
  ;

  const UserSubscriptionsKey(this.name);
  final String name;
}

abstract class UserSubscriptionDatasource {
  Future<Either<Failure, List<UserSubscription>>> createUserSubscriptions(
      List<UserSubscriptionEntity> subscriptions);
  Future<Either<Failure, List<UserSubscription>>> deleteUserSubscriptions(
      List<UserSubscriptionEntity> subscriptions);
  Future<Either<Failure, bool>> resetAllUserSubscriptions();
  Future<Either<Failure, List<UserSubscription>>> getUserSubscriptions();
  Stream<List<UserSubscription>> subscribeUserSubscriptions();
}

class UserSubscriptionDatasourceImpl implements UserSubscriptionDatasource {
  final box = Get.find<HiveProvider>().userSubscriptions!;

  @override
  Future<Either<Failure, List<UserSubscription>>> createUserSubscriptions(
      List<UserSubscriptionEntity> newSubscriptions) async {
    try {
      List<dynamic> subscriptions = _getUserSubscriptions();

      subscriptions.addAll(newSubscriptions);

      await box.put(UserSubscriptionsKey.all.name, subscriptions);

      return Right(toUserSubscriptionsModelAll());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<UserSubscription>>> deleteUserSubscriptions(
      List<UserSubscriptionEntity> removeSubscriptions) async {
    try {
      List<dynamic> subscriptions = _getUserSubscriptions();
      subscriptions.removeWhere((subscription) =>
          removeSubscriptions.any((rc) => rc.id == subscription.id));

      await box.put(UserSubscriptionsKey.all.name, subscriptions);

      return Right(toUserSubscriptionsModelAll());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> resetAllUserSubscriptions() async {
    try {
      await box.put(UserSubscriptionsKey.all.name, []);
      return const Right(true);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<UserSubscription>>> getUserSubscriptions() async {
    try {
      return Right(toUserSubscriptionsModelAll());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Stream<List<UserSubscription>> subscribeUserSubscriptions() {
    return box.watch().map((event) {
      return toUserSubscriptionsModelAll();
    });
  }

  List<dynamic> _getUserSubscriptions() {
    return box.get(UserSubscriptionsKey.all.name, defaultValue: []);
  }

  List<UserSubscription> toUserSubscriptionsModelAll() {
    return _getUserSubscriptions()
        .map((subscription) => UserSubscription(
              id: subscription.id,
              platformId: subscription.platformId,
            ))
        .toList();
  }
}
