// ignore_for_file: non_constant_identifier_names

import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/app/utils/log.dart';
import 'package:zippy/data/entity/channel_entity.dart';
import 'package:zippy/data/providers/supabase_provider.dart';
import 'package:zippy/data/sources/interfaces/channel_data_source.dart';
import 'package:zippy/domain/model/channel.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';

String TABLE = 'channel';

class ChannelDatasourceIml implements ChannelDatasource {
  SupabaseProvider provider = Get.find();

  @override
  Future<Either<Failure, List<Channel>>> getChannels(
      {bool withCategory = false}) async {
    try {
      String select = '*';
      Map<String, dynamic> condition = {'status': true};

      if (withCategory) {
        select += ', category!channel_id(*)';
        condition['category.status'] = true;
      }

      List<Map<String, dynamic>> response =
          await provider.client.from(TABLE).select(select).match(condition);

      List<Channel> result =
          response.map((r) => ChannelEntity.fromJson(r).toModel()).toList();
      return Right(result);
    } catch (e) {
      print(e);
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Channel>> getChannel(int id) async {
    try {
      Map<String, dynamic> response = await provider.client
          .from(TABLE)
          .select('*')
          .eq('id', id)
          .eq('status', true)
          .single();

      Channel result = ChannelEntity.fromJson(response).toModel();

      return Right(result);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
