import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/entity/user_subscription.entity.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:zippy/data/providers/supabase.provider.dart';
import 'package:zippy/domain/model/params/create_or_delete_user_subscription.params.dart';
import 'package:zippy/domain/model/user_subscription.model.dart';

String TABLE = 'user_subscriptions';

abstract class UserSubscriptionDatasource {
  Future<Either<Failure, bool>> createUserSubscriptions(
      CreateOrDeleteUserSubscriptionParams params);
  Future<Either<Failure, bool>> deleteUserSubscriptions(
      CreateOrDeleteUserSubscriptionParams params);
  Future<Either<Failure, List<UserSubscription>>> getUserSubscriptions(
      String userId);
  RealtimeChannel listenUserSubscriptionChanges(
      String userId, VoidCallback callback);
}

class UserSubscriptionDatasourceImpl implements UserSubscriptionDatasource {
  SupabaseProvider provider = Get.find();

  @override
  Future<Either<Failure, bool>> createUserSubscriptions(
      CreateOrDeleteUserSubscriptionParams params) async {
    try {
      await provider.client.from(TABLE).insert(params.toJson());
      return const Right(true);
    } catch (e, stackTrace) {
      print('Error:$e \n stackTrace:$stackTrace');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> deleteUserSubscriptions(
      CreateOrDeleteUserSubscriptionParams params) async {
    try {
      await provider.client.from(TABLE).delete().match({
        'user_id': params.userId,
        'content_type_id': params.contentTypeId,
      });
      return const Right(true);
    } catch (e, stackTrace) {
      print('Error:$e \n stackTrace:$stackTrace');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<UserSubscription>>> getUserSubscriptions(
      String userId) async {
    try {
      List<Map<String, dynamic>> response =
          await provider.client.from(TABLE).select('*').eq('user_id', userId);

      return Right(response
          .map((r) => UserSubscriptionEntity.fromJson(r).toModel())
          .toList());
    } catch (e, stackTrace) {
      print('Error:$e \n stackTrace:$stackTrace');
      return Left(ServerFailure());
    }
  }

  @override
  RealtimeChannel listenUserSubscriptionChanges(
      String userId, VoidCallback callback) {
    final channel = provider.client.channel('public:$TABLE').onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: TABLE,
          filter: PostgresChangeFilter(
            column: 'user_id',
            type: PostgresChangeFilterType.eq,
            value: userId,
          ),
          callback: (payload) {
            callback();
          },
        );

    return channel;
  }
}
