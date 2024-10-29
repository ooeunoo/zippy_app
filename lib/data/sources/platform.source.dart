// ignore_for_file: non_constant_identifier_names

import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/entity/platform.entity.dart';
import 'package:zippy/data/providers/supabase.provider.dart';
import 'package:zippy/domain/model/platform.model.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';

String TABLE = 'platforms';

abstract class PlatformDatasource {
  Future<Either<Failure, List<Platform>>> getPlatforms(
      {bool withSources = false});
  Future<Either<Failure, Platform>> getPlatform(int id);
}

class PlatformDatasourceImpl implements PlatformDatasource {
  SupabaseProvider provider = Get.find();

  @override
  Future<Either<Failure, List<Platform>>> getPlatforms(
      {bool withSources = false}) async {
    try {
      String select = 'id, type, name, status, image_url';
      Map<String, Object> condition = {'status': true};

      if (withSources) {
        select += ', sources(id, platform_id, category, status, type)';
        condition['sources.status'] = true;
      }

      List<Map<String, dynamic>> response =
          await provider.client.from(TABLE).select(select).match(condition);
      List<Platform> result =
          response.map((r) => PlatformEntity.fromJson(r).toModel()).toList();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Platform>> getPlatform(int id) async {
    try {
      Map<String, dynamic> response = await provider.client
          .from(TABLE)
          .select('*')
          .eq('id', id)
          .eq('status', true)
          .single();

      Platform result = PlatformEntity.fromJson(response).toModel();

      return Right(result);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
