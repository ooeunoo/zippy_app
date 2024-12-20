import 'package:get/get.dart';
import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/domain/model/keyword_rank_snaoshot.model.dart';
import 'package:zippy/domain/model/params/get_tranding_keywords.params.dart';
import 'package:dartz/dartz.dart';
import 'package:zippy/domain/repositories/keyword_rank_snapshot.repository.dart';

class GetTrendingKeywords {
  final KeywordRankSnapshotRepository repo;

  GetTrendingKeywords(this.repo);

  Future<Either<Failure, List<KeywordRankSnapshot>>> execute(
      GetTrandingKeywordsParams params) {
    return repo.getTrendingKeywords(params);
  }
}
