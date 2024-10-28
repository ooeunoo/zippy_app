import 'package:zippy/app/failures/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:zippy/domain/repositories/user_category.repository.dart';

class ResetUserSubscription {
  final UserSubscriptionRepository repo;

  ResetUserSubscription(this.repo);

  Future<Either<Failure, bool>> execute() {
    return repo.resetAllUserSubscriptions();
  }
}
