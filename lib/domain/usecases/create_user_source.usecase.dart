import 'package:zippy/app/failures/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:zippy/data/entity/user_subscription.entity.dart';
import 'package:zippy/domain/model/user_subscription.model.dart';
import 'package:zippy/domain/repositories/user_category.repository.dart';

class CreateUserSubscription {
  final UserSubscriptionRepository repo;

  CreateUserSubscription(this.repo);

  Future<Either<Failure, List<UserSubscription>>> execute(
      List<UserSubscriptionEntity> subscriptions) {
    return repo.createUserSubscriptions(subscriptions);
  }
}
