import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/entity/source.entity.dart';
import 'package:zippy/data/providers/supabase.provider.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:zippy/domain/model/source.model.dart';

String TABLE = 'sources';

abstract class SourceDatasource {
  Future<Either<Failure, List<Source>>> getSources({String? channelId});
  Future<Either<Failure, Source>> getSource(int id);
}

class SourceDatasourceImpl implements SourceDatasource {
  SupabaseProvider provider = Get.find();

  @override
  Future<Either<Failure, List<Source>>> getSources({String? channelId}) async {
    try {
      Map<String, Object> where = {};

      if (channelId != null) {
        where['channel_id'] = channelId;
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
