import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/sources/user_interaction.source.dart';
import 'package:zippy/domain/model/params/create_user_interaction.params.dart';
import 'package:zippy/domain/model/params/update_user_interaction.params.dart';
import 'package:dartz/dartz.dart';
import 'package:zippy/domain/model/user_interaction.model%20.dart';

abstract class UserInteractionRepository {
  Future<Either<Failure, UserInteraction>> createUserInteraction(
      CreateUserInteractionParams params);
  Future<Either<Failure, bool>> updateUserInteraction(
      UpdateUserInteractionParams params);
}

class UserInteractionRepositoryImpl implements UserInteractionRepository {
  final UserInteractionDatasource datasource;

  UserInteractionRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, UserInteraction>> createUserInteraction(
      CreateUserInteractionParams params) async {
    return await datasource.createUserInteraction(params);
  }

  @override
  Future<Either<Failure, bool>> updateUserInteraction(
      UpdateUserInteractionParams params) async {
    return await datasource.updateUserInteraction(params);
  }
}
