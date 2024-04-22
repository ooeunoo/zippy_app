import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/entity/user_community_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:zippy/domain/repositories/interfaces/user_community_repository.dart';

class DeleteUserCommunity {
  final UserCommunityRepository repo;

  DeleteUserCommunity(this.repo);

  Future<Either<Failure, bool>> execute(UserCommunityEntity userCommunity) {
    return repo.deleteUserCommunity(userCommunity);
  }
}
