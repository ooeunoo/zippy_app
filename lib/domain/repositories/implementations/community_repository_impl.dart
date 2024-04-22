import 'package:cocomu/app/failures/failure.dart';
import 'package:cocomu/data/sources/interfaces/community_data_source.dart';
import 'package:cocomu/domain/model/community.dart';
import 'package:cocomu/domain/repositories/interfaces/community_repository.dart';
import 'package:dartz/dartz.dart';

class CommunityRepositoryImpl implements CommunityRepository {
  final CommunityDatasource datasource;

  CommunityRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<Community>>> getCommunites() {
    return datasource.getCommunites();
  }

  @override
  Future<Either<Failure, Community>> getCommunity(int id) {
    return datasource.getCommunity(id);
  }
}
