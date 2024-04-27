import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/sources/interfaces/user_data_source.dart';
import 'package:zippy/domain/model/user.dart';
import 'package:zippy/domain/repositories/interfaces/user_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDatasource datasource;

  UserRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, UserModel>> getUser(String id) {
    return datasource.getUser(id);
  }

  @override
  Future<Either<Failure, bool>> loginWithNaver() {
    return datasource.loginWithNaver();
  }

  @override
  Future<Either<Failure, bool>> loginWithApple() {
    return datasource.loginWithApple();
  }

  @override
  Future<Either<Failure, bool>> loginWithGoogle() {
    return datasource.loginWithGoogle();
  }

  @override
  Future<Either<Failure, bool>> loginWithKakao() {
    return datasource.loginWithKakao();
  }

  @override
  Future<Either<Failure, bool>> logout() {
    return datasource.logout();
  }

  @override
  Stream<User?> subscribeUser() {
    return datasource.subscribeUser();
  }
}
