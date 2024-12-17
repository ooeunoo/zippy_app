import 'package:dartz/dartz.dart';
import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/domain/model/user_keyword_notification.model.dart';
import 'package:zippy/domain/repositories/user_keyword_notification.repository.dart';

class GetUserKeywordNotifications {
  final UserKeywordNotificationRepository repo;

  GetUserKeywordNotifications(this.repo);

  Future<Either<Failure, List<UserKeywordNotification>>> execute(
      String userId) {
    return repo.getUserKeywordNotifications(userId);
  }
}
