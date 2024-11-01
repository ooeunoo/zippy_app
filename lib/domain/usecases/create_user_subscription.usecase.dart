import 'package:zippy/app/failures/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:zippy/domain/model/params/create_user_subscription.params.dart';
import 'package:zippy/domain/repositories/user_category.repository.dart';

class CreateUserSubscription {
  final UserSubscriptionRepository repo;

  CreateUserSubscription(this.repo);

  Future<Either<Failure, bool>> execute(
      CreateUserSubscriptionParams subscriptions) {
    return repo.createUserSubscriptions(subscriptions);
  }
}
