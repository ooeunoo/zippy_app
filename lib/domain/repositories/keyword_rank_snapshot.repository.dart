import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/sources/keyword_rank_snapshot.source.dart';
import 'package:zippy/domain/model/keyword_rank_snaoshot.model.dart';
import 'package:dartz/dartz.dart';
import 'package:zippy/domain/model/params/get_tranding_keywords.params.dart';

abstract class KeywordRankSnapshotRepository {
  Future<Either<Failure, List<KeywordRankSnapshot>>> getTrendingKeywords(
      GetTrandingKeywordsParams params);
}

class KeywordRankSnapshotRepositoryImpl
    implements KeywordRankSnapshotRepository {
  final KeywordRankSnapshotDatasource datasource;

  KeywordRankSnapshotRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<KeywordRankSnapshot>>> getTrendingKeywords(
      GetTrandingKeywordsParams params) {
    return datasource.getTrendingKeywords(params);
  }
}
