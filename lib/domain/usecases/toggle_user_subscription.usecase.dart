import 'package:zippy/app/failures/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:zippy/domain/model/params/create_or_delete_user_subscription.params.dart';
import 'package:zippy/domain/repositories/user_category.repository.dart';

class ToggleUserSubscription {
  final UserSubscriptionRepository repo;

  ToggleUserSubscription(this.repo);

  Future<Either<Failure, bool>> execute(
      CreateOrDeleteUserSubscriptionParams subscriptions) {
    return repo.toggleUserSubscription(subscriptions);
  }
}
