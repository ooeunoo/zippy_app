import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/entity/user_community_entity.dart';
import 'package:zippy/data/sources/interfaces/user_community_data_source.dart';
import 'package:zippy/domain/model/user_community.dart';
import 'package:dartz/dartz.dart';
import 'package:zippy/domain/repositories/interfaces/user_community_repository.dart';

class UserCommunityRepositoryImpl implements UserCommunityRepository {
  final UserCommunityDatasource datasource;

  UserCommunityRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<UserCommunity>>> getUserCommunityByUserId(
      String userId) {
    return datasource.getUserCommunities(userId);
  }

  @override
  Future<Either<Failure, bool>> createUserCommunity(
      UserCommunityEntity userCommunity) {
    return datasource.createUserCommunity(userCommunity);
  }

  @override
  Future<Either<Failure, bool>> deleteUserCommunity(
      UserCommunityEntity userCommunity) {
    return datasource.deleteUserCommunity(userCommunity);
  }
}
