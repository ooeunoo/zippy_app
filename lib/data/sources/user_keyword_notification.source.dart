import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/entity/user_keyword_notification.entity.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:zippy/data/providers/supabase.provider.dart';
import 'package:zippy/domain/model/params/create_user_keyword_notification.params.dart';
import 'package:zippy/domain/model/user_keyword_notification.model.dart';

abstract class UserKeywordNotificationDatasource {
  Future<Either<Failure, List<UserKeywordNotification>>>
      getUserKeywordNotifications(String userId);
  Future<Either<Failure, bool>> toggleUserKeywordNotification(
      int id, bool isActive);
  Future<Either<Failure, bool>> createUserKeywordNotification(
      CreateUserKeywordNotificationParams params);
  Future<Either<Failure, bool>> deleteUserKeywordNotification(int id);
}

class UserKeywordNotificationDatasourceImpl
    implements UserKeywordNotificationDatasource {
  final SupabaseProvider provider = Get.find();
  final String TABLE = 'user_keyword_notifications';

  @override
  Future<Either<Failure, bool>> toggleUserKeywordNotification(
      int id, bool isActive) async {
    try {
      await provider.client.from(TABLE).update({
        'is_active': isActive,
      }).eq('id', id);

      return const Right(true);
    } catch (e, stackTrace) {
      print('Error:$e \n stackTrace:$stackTrace');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<UserKeywordNotification>>>
      getUserKeywordNotifications(String userId) async {
    try {
      final response =
          await provider.client.from(TABLE).select('*').eq('user_id', userId);

      return Right(
        response
            .map((r) => UserKeywordNotificationEntity.fromJson(r).toModel())
            .toList(),
      );
    } catch (e, stackTrace) {
      print('Error:$e \n stackTrace:$stackTrace');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> createUserKeywordNotification(
      CreateUserKeywordNotificationParams params) async {
    try {
      await provider.client.from(TABLE).insert(params.toJson());
      return const Right(true);
    } catch (e, stackTrace) {
      print('Error:$e \n stackTrace:$stackTrace');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> deleteUserKeywordNotification(int id) async {
    try {
      await provider.client.from(TABLE).delete().eq('id', id);
      return const Right(true);
    } catch (e, stackTrace) {
      print('Error:$e \n stackTrace:$stackTrace');
      return Left(ServerFailure());
    }
  }
}
