import 'package:zippy/app/failures/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:zippy/domain/model/params/create_user_interaction.params.dart';
import 'package:zippy/domain/repositories/user_interaction.repository.dart';

class CreateUserInteraction {
  final UserInteractionRepository repo;

  CreateUserInteraction(this.repo);

  Future<Either<Failure, bool>> execute(CreateUserInteractionParams params) {
    return repo.createUserInteraction(params);
  }
}
