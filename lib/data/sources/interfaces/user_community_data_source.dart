import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/entity/bookmark_entity.dart';
import 'package:zippy/data/entity/user_community_entity.dart';
import 'package:zippy/domain/model/bookmark.dart';
import "package:dartz/dartz.dart";
import 'package:zippy/domain/model/user_community.dart';

abstract class UserCommunityDatasource {
  Future<Either<Failure, List<UserCommunity>>> getUserCommunities(
      String userId);
  Future<Either<Failure, bool>> createUserCommunity(
      UserCommunityEntity userCommunity);
  Future<Either<Failure, bool>> deleteUserCommunity(
      UserCommunityEntity userCommunity);
}
