import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/entity/user_subscription.entity.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:zippy/data/providers/supabase.provider.dart';
import 'package:zippy/domain/model/params/create_or_delete_user_subscription.params.dart';
import 'package:zippy/domain/model/user_subscription.model.dart';

abstract class UserSubscriptionDatasource {
  Future<Either<Failure, List<UserSubscription>>> getUserSubscriptions(
      String userId);
  Future<Either<Failure, bool>> toggleUserSubscription(
      CreateOrDeleteUserSubscriptionParams params);
  Stream<List<UserSubscription>> getUserSubscriptionsStream(String userId);
}

class UserSubscriptionDatasourceImpl implements UserSubscriptionDatasource {
  SupabaseProvider provider = Get.find();
  final String TABLE = 'user_subscriptions';

  @override
  Future<Either<Failure, bool>> toggleUserSubscription(
      CreateOrDeleteUserSubscriptionParams params) async {
    try {
      // First try to find existing subscription
      final response = await provider.client
          .from(TABLE)
          .select('id, is_active')
          .eq('user_id', params.userId)
          .eq('content_type_id', params.contentTypeId)
          .maybeSingle();

      if (response == null) {
        // If no subscription exists, create a new one
        await provider.client.from(TABLE).insert({
          'user_id': params.userId,
          'content_type_id': params.contentTypeId,
          'is_active': true,
        });
      } else {
        // If subscription exists, just toggle is_active
        await provider.client
            .from(TABLE)
            .update({
              'is_active': !response['is_active'],
            })
            .eq('id', response['id'])
            .eq('user_id', params.userId) // Extra safety check
            .eq('content_type_id', params.contentTypeId); // Extra safety check
      }

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
      final response = await provider.client
          .from(TABLE)
          .select('*')
          .eq('user_id', userId)
          .eq('is_active', true);

      return Right(
        response
            .map((r) => UserSubscriptionEntity.fromJson(r).toModel())
            .toList(),
      );
    } catch (e, stackTrace) {
      print('Error:$e \n stackTrace:$stackTrace');
      return Left(ServerFailure());
    }
  }

  @override
  Stream<List<UserSubscription>> getUserSubscriptionsStream(String userId) {
    return provider.client
        .from(TABLE)
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .map((value) => value
            .map((e) => UserSubscriptionEntity.fromJson(e).toModel())
            .toList());
  }
}
