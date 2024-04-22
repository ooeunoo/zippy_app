import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/domain/model/user_community.dart';
import 'package:dartz/dartz.dart';
import 'package:zippy/domain/repositories/interfaces/user_community_repository.dart';

class GetUserCommunityByUserId {
  final UserCommunityRepository repo;

  GetUserCommunityByUserId(this.repo);

  Future<Either<Failure, List<UserCommunity>>> execute(String userId) {
    return repo.getUserCommunityByUserId(userId);
  }
}
