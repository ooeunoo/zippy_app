import 'package:cocomu/app/failures/failure.dart';
import 'package:cocomu/domain/model/user.dart';
import 'package:cocomu/domain/repositories/interfaces/user_repository.dart';
import 'package:dartz/dartz.dart';

class GetUser {
  final UserRepository repo;

  GetUser(this.repo);

  Future<Either<Failure, UserModel>> execute(String id) {
    return repo.getUser(id);
  }
}
