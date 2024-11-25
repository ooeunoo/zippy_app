import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/sources/auth.source.dart';
import 'package:zippy/domain/model/user.model.dart';

abstract class AuthRepository {
  Future<Either<Failure, User?>> getCurrentUser();
  Stream<Tuple2<supabase.AuthChangeEvent, User?>> subscribeAuthStatus();
  Future<Either<Failure, bool>> logout();
  Future<Either<Failure, bool>> loginWithKakao();
  Future<Either<Failure, bool>> loginWithGoogle();
  Future<Either<Failure, bool>> loginWithApple();
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthDatasource datasource;

  AuthRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    return datasource.getCurrentUser();
  }

  @override
  Stream<Tuple2<supabase.AuthChangeEvent, User?>> subscribeAuthStatus() {
    return datasource.subscribeAuthStatus();
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    return datasource.logout();
  }

  @override
  Future<Either<Failure, bool>> loginWithKakao() async {
    return datasource.loginInWithKakao();
  }

  @override
  Future<Either<Failure, bool>> loginWithGoogle() async {
    return datasource.loginInWithGoogle();
  }

  @override
  Future<Either<Failure, bool>> loginWithApple() async {
    return datasource.loginInWithApple();
  }
}
