import 'package:zippy/app/failures/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:zippy/domain/model/params/update_user_interaction.params.dart';
import 'package:zippy/domain/repositories/user_interaction.repository.dart';

class UpdateUserInteraction {
  final UserInteractionRepository repo;

  UpdateUserInteraction(this.repo);

  Future<Either<Failure, bool>> execute(UpdateUserInteractionParams params) {
    return repo.updateUserInteraction(params);
  }
}
