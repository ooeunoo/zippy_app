import 'package:zippy/app/failures/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:zippy/domain/repositories/user_category.repository.dart';

class DeleteUserSubscription {
  final UserSubscriptionRepository repo;

  DeleteUserSubscription(this.repo);

  Future<Either<Failure, bool>> execute(int subscriptionId) {
    return repo.deleteUserSubscriptions(subscriptionId);
  }
}
