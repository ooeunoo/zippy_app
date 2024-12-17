import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/sources/user_keyword_notification.source.dart';
import 'package:zippy/domain/model/params/create_user_keyword_notification.params.dart';
import 'package:zippy/domain/model/user_keyword_notification.model.dart';
import 'package:dartz/dartz.dart';

abstract class UserKeywordNotificationRepository {
  Future<Either<Failure, List<UserKeywordNotification>>>
      getUserKeywordNotifications(String userId);
  Future<Either<Failure, bool>> toggleUserKeywordNotification(
      int id, bool isActive);
  Future<Either<Failure, bool>> createUserKeywordNotification(
      CreateUserKeywordNotificationParams params);

  Future<Either<Failure, bool>> deleteUserKeywordNotification(int id);
}

class UserKeywordNotificationRepositoryImpl
    implements UserKeywordNotificationRepository {
  final UserKeywordNotificationDatasource datasource;

  UserKeywordNotificationRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, bool>> toggleUserKeywordNotification(
      int id, bool isActive) {
    return datasource.toggleUserKeywordNotification(id, isActive);
  }

  @override
  Future<Either<Failure, List<UserKeywordNotification>>>
      getUserKeywordNotifications(String userId) {
    return datasource.getUserKeywordNotifications(userId);
  }

  @override
  Future<Either<Failure, bool>> createUserKeywordNotification(
      CreateUserKeywordNotificationParams params) {
    return datasource.createUserKeywordNotification(params);
  }

  @override
  Future<Either<Failure, bool>> deleteUserKeywordNotification(int id) {
    return datasource.deleteUserKeywordNotification(id);
  }
}
