import 'package:dartz/dartz.dart';
import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/domain/repositories/user_keyword_notification.repository.dart';

class DeleteUserKeywordNotification {
  final UserKeywordNotificationRepository repo;

  DeleteUserKeywordNotification(this.repo);

  Future<Either<Failure, bool>> execute(int id) {
    return repo.deleteUserKeywordNotification(id);
  }
}
