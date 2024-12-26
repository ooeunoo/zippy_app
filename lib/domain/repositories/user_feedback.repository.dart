import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/sources/article_comment.source.dart';
import 'package:zippy/data/sources/user_feedback.source.dart';
import 'package:zippy/domain/model/article_comment.model.dart';
import 'package:dartz/dartz.dart';
import 'package:zippy/domain/model/params/create_article_comment.params.dart';
import 'package:zippy/domain/model/params/create_user_feedback.params.dart';

abstract class UserFeedbackRepository {
  Future<Either<Failure, bool>> createUserFeedback(
      CreateUserFeedbackParams params);
}

class UserFeedbackRepositoryImpl implements UserFeedbackRepository {
  final UserFeedbackDatasource datasource;

  UserFeedbackRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, bool>> createUserFeedback(
      CreateUserFeedbackParams params) {
    return datasource.createUserFeedback(params);
  }
}
