import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/entity/user_community_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:zippy/domain/model/user_community.dart';

abstract class UserCommunityRepository {
  Future<Either<Failure, List<UserCommunity>>> getUserCommunityByUserId(
      String userId);
  Future<Either<Failure, bool>> createUserCommunity(
      UserCommunityEntity userCommunity);
  Future<Either<Failure, bool>> deleteUserCommunity(
      UserCommunityEntity userCommunity);
}
