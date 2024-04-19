import 'package:cocomu/app/failures/failure.dart';
import 'package:cocomu/domain/model/community.dart';
import "package:dartz/dartz.dart";

abstract class CommunityDatasource {
  Future<Either<Failure, List<Community>>> getCommunites();
  Future<Either<Failure, Community>> getCommunity(int id);
}
