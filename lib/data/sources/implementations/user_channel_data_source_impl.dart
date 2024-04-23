// ignore_for_file: non_constant_identifier_names

import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/entity/user_channel_entity.dart';
import 'package:zippy/data/providers/supabase_provider.dart';
import 'package:zippy/data/sources/interfaces/user_channel_data_source.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:zippy/domain/model/user_channel.dart';

String TABLE = 'user_channel';

class UserChannelDatasourceIml implements UserChannelDatasource {
  SupabaseProvider provider = Get.find();

  @override
  Future<Either<Failure, bool>> createUserChannel(
      List<UserChannelEntity> channels) async {
    try {
      List<Map<String, dynamic>> channelParamsList = [];

      for (UserChannelEntity channel in channels) {
        channelParamsList.add(channel.toParams());
      }

      await provider.client.from(TABLE).insert(channelParamsList);
      return const Right(true);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> deleteUserChannel(
      List<UserChannelEntity> channels) async {
    try {
      for (UserChannelEntity channel in channels) {
        await provider.client.from(TABLE).delete().match(channel.toParams());
      }
      return const Right(true);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<UserChannel>>> getUserChannels(
      String userId) async {
    try {
      List<Map<String, dynamic>> response = await provider.client
          .from(TABLE)
          .select('*, category(*)')
          .match({"user_id": userId});
      List<UserChannel> result =
          response.map((r) => UserChannelEntity.fromJson(r).toModel()).toList();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Stream<List<UserChannel>> subscribeUserChannel(String userId) {
    return provider.client
        .from(TABLE)
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .map((data) => data.map((item) {
              return UserChannelEntity.fromJson(item).toModel();
            }).toList());
  }
}
