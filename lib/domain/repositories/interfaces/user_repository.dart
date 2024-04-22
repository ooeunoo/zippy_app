import 'package:cocomu/app/failures/failure.dart';
import 'package:cocomu/domain/model/category.dart';
import 'package:cocomu/domain/model/user.dart';
import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class UserRepository {
  Future<Either<Failure, bool>> loginWithKakao();
  Future<Either<Failure, bool>> loginWithApple();
  Future<Either<Failure, bool>> logout();
  Future<Either<Failure, UserModel>> getUser(String id);
  Stream<User?> subscribeUser();
}
