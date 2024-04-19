// ignore_for_file: non_constant_identifier_names

import 'package:cocomu/app/failures/failure.dart';
import 'package:cocomu/data/entity/community_entity.dart';
import 'package:cocomu/data/providers/supabase_provider.dart';
import 'package:cocomu/data/sources/interfaces/community_data_source.dart';
import 'package:cocomu/domain/model/community.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';

String TABLE = 'community';

class CommunityDatasourceIml implements CommunityDatasource {
  SupabaseProvider provider = Get.find();

  @override
  Future<Either<Failure, List<Community>>> getCommunites() async {
    try {
      List<Map<String, dynamic>> response =
          await provider.client.from(TABLE).select('*');

      List<Community> result =
          response.map((r) => CommunityEntity.fromJson(r).toModel()).toList();

      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Community>> getCommunity(int id) async {
    try {
      Map<String, dynamic> response =
          await provider.client.from(TABLE).select('*').eq('id', id).single();

      Community result = CommunityEntity.fromJson(response).toModel();

      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
