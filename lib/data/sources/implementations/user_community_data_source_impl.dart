// ignore_for_file: non_constant_identifier_names

import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/entity/user_community_entity.dart';
import 'package:zippy/data/providers/supabase_provider.dart';
import 'package:zippy/data/sources/interfaces/user_community_data_source.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:zippy/domain/model/user_community.dart';

String TABLE = 'user_community';

class UserCommunityDatasourceIml implements UserCommunityDatasource {
  SupabaseProvider provider = Get.find();

  @override
  Future<Either<Failure, bool>> createUserCommunity(
      UserCommunityEntity userCommunity) async {
    try {
      await provider.client.from(TABLE).insert(userCommunity.toParams());
      return const Right(true);
    } catch (e) {
      print(e);
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> deleteUserCommunity(
      UserCommunityEntity userCommunity) async {
    try {
      await provider.client
          .from(TABLE)
          .delete()
          .match(userCommunity.toParams());
      return const Right(true);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<UserCommunity>>> getUserCommunities(
      String userId) async {
    try {
      List<Map<String, dynamic>> response = await provider.client
          .from(TABLE)
          .select('*')
          .match({"user_id": userId});

      List<UserCommunity> result = response
          .map((r) => UserCommunityEntity.fromJson(r).toModel())
          .toList();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
