import 'package:dartz/dartz.dart';
import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/domain/model/params/create_user_keyword_notification.params.dart';
import 'package:zippy/domain/repositories/user_keyword_notification.repository.dart';

class ToggleUserKeywordNotification {
  final UserKeywordNotificationRepository repo;

  ToggleUserKeywordNotification(this.repo);

  Future<Either<Failure, bool>> execute(int id, bool isActive) {
    return repo.toggleUserKeywordNotification(id, isActive);
  }
}
