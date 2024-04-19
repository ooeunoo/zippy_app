import 'package:cocomu/app/failures/failure.dart';
import 'package:cocomu/domain/model/community.dart';
import 'package:cocomu/domain/repositories/interfaces/community_repository.dart';
import 'package:dartz/dartz.dart';

class GetCommunites {
  final CommunityRepository repo;

  GetCommunites(this.repo);

  Future<Either<Failure, List<Community>>> execute() {
    return repo.getCommunites();
  }
}
