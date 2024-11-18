import 'dart:async';

import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/entity/keyword_rank_snapshot.entity.dart';
import 'package:zippy/data/providers/supabase.provider.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:zippy/domain/model/keyword_rank_snaoshot.model.dart';
import 'package:zippy/domain/model/params/get_tranding_keywords.params.dart';

String TABLE = 'keyword_rank_snapshots';

enum RPC {
  GET_TRANDING_KEYWORDS('get_trending_keywords'),
  ;

  final String function;

  const RPC(this.function);
}

abstract class KeywordRankSnapshotDatasource {
  Future<Either<Failure, List<KeywordRankSnapshot>>> getTrendingKeywords(
    GetTrandingKeywordsParams params,
  );
}

class KeywordRankSnapshotDatasourceImpl
    implements KeywordRankSnapshotDatasource {
  SupabaseProvider provider = Get.find();

  @override
  Future<Either<Failure, List<KeywordRankSnapshot>>> getTrendingKeywords(
      GetTrandingKeywordsParams params) async {
    try {
      List<Map<String, dynamic>> response = await provider.client
          .rpc(RPC.GET_TRANDING_KEYWORDS.function, params: params.toJson());

      List<KeywordRankSnapshot> result = response
          .map((r) => KeywordRankSnapshotEntity.fromJson(r).toModel())
          .toList();

      return Right(result);
    } catch (e, stackTrace) {
      print('Error:$e \n stackTrace:$stackTrace');
      return Left(ServerFailure());
    }
  }
}
