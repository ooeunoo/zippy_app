import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/domain/model/community.dart';
import "package:dartz/dartz.dart";

abstract class CommunityDatasource {
  Future<Either<Failure, List<Community>>> getCommunites();
  Future<Either<Failure, Community>> getCommunity(int id);
}
