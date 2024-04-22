import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/domain/model/community.dart';
import 'package:zippy/domain/repositories/interfaces/community_repository.dart';
import 'package:dartz/dartz.dart';

class GetCommunites {
  final CommunityRepository repo;

  GetCommunites(this.repo);

  Future<Either<Failure, List<Community>>> execute() {
    return repo.getCommunites();
  }
}
