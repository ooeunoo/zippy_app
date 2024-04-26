import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/domain/model/category.dart';
import 'package:zippy/domain/model/user.dart';
import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class UserRepository {
  Future<Either<Failure, bool>> loginWithNaver();
  Future<Either<Failure, bool>> loginWithKakao();
  Future<Either<Failure, bool>> loginWithApple();
  Future<Either<Failure, bool>> logout();
  Future<Either<Failure, UserModel>> getUser(String id);
  Stream<User?> subscribeUser();
}
