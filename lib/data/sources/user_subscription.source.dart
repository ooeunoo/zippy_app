import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/entity/user_subscription.entity.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:zippy/data/providers/supabase.provider.dart';
import 'package:zippy/domain/model/params/create_user_subscription.params.dart';
import 'package:zippy/domain/model/user_subscription.model.dart';

String TABLE = 'user_subscriptions';

abstract class UserSubscriptionDatasource {
  Future<Either<Failure, bool>> createUserSubscriptions(
      CreateUserSubscriptionParams params);
  Future<Either<Failure, bool>> deleteUserSubscriptions(int subscriptionId);
  Future<Either<Failure, List<UserSubscription>>> getUserSubscriptions();
  Stream<List<UserSubscription>> subscribeUserSubscriptions(String userId);
}

class UserSubscriptionDatasourceImpl implements UserSubscriptionDatasource {
  SupabaseProvider provider = Get.find();

  @override
  Future<Either<Failure, bool>> createUserSubscriptions(
      CreateUserSubscriptionParams params) async {
    try {
      await provider.client.from(TABLE).insert(params.toJson());
      return const Right(true);
    } catch (e) {
      print(e);
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> deleteUserSubscriptions(
      int subscriptionId) async {
    try {
      await provider.client.from(TABLE).delete().eq('id', subscriptionId);
      return const Right(true);
    } catch (e) {
      print(e);
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<UserSubscription>>> getUserSubscriptions() async {
    try {
      List<Map<String, dynamic>> response =
          await provider.client.from(TABLE).select('*');

      return Right(response
          .map((r) => UserSubscriptionEntity.fromJson(r).toModel())
          .toList());
    } catch (e) {
      print(e);
      return Left(ServerFailure());
    }
  }

  @override
  Stream<List<UserSubscription>> subscribeUserSubscriptions(String userId) {
    return provider.client
        .from(TABLE)
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .map((event) => event
            .map((r) => UserSubscriptionEntity.fromJson(r).toModel())
            .toList());
  }
}
