import 'package:zippy/app/failures/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:zippy/domain/model/user_subscription.model.dart';
import 'package:zippy/domain/repositories/user_category.repository.dart';

class GetUserSubscriptions {
  final UserSubscriptionRepository repo;

  GetUserSubscriptions(this.repo);

  Future<Either<Failure, List<UserSubscription>>> execute() {
    return repo.getUserSubscriptions();
  }
}
