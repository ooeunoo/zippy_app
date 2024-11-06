import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/entity/source.entity.dart';
import 'package:zippy/data/providers/supabase.provider.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:zippy/domain/model/source.model.dart';

String TABLE = 'sources';

abstract class SourceDatasource {
  Future<Either<Failure, List<Source>>> getSources({bool withJoin = false});
  Future<Either<Failure, List<Source>>> getSourcesByPlatformId(
      {String? platformId});
  Future<Either<Failure, Source>> getSource(int id);
}

class SourceDatasourceImpl implements SourceDatasource {
  SupabaseProvider provider = Get.find();

  @override
  Future<Either<Failure, List<Source>>> getSources(
      {bool withJoin = false}) async {
    try {
      String select = withJoin ? '*, content_types(*)' : '*';

      List<Map<String, dynamic>> response =
          await provider.client.from(TABLE).select(select).eq('status', true);

      print('response: $response');
      List<Source> result =
          response.map((r) => SourceEntity.fromJson(r).toModel()).toList();

      return Right(result);
    } catch (e) {
      print('error: $e');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Source>>> getSourcesByPlatformId(
      {String? platformId}) async {
    try {
      Map<String, Object> where = {};

      if (platformId != null) {
        where['platform_id'] = platformId;
      }

      List<Map<String, dynamic>> response = await provider.client
          .from(TABLE)
          .select('*')
          .eq('status', true)
          .match(where);

      List<Source> result =
          response.map((r) => SourceEntity.fromJson(r).toModel()).toList();

      return Right(result);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Source>> getSource(int id) async {
    try {
      Map<String, dynamic> response = await provider.client
          .from(TABLE)
          .select('*')
          .eq('id', id)
          .eq('status', true)
          .single();

      Source result = SourceEntity.fromJson(response).toModel();

      return Right(result);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
