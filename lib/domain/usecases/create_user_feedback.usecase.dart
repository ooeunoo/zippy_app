import 'package:zippy/app/failures/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:zippy/domain/model/params/create_user_feedback.params.dart';
import 'package:zippy/domain/repositories/user_feedback.repository.dart';

class CreateUserFeedback {
  final UserFeedbackRepository repo;

  CreateUserFeedback(this.repo);

  Future<Either<Failure, bool>> execute(CreateUserFeedbackParams feedback) {
    return repo.createUserFeedback(feedback);
  }
}
