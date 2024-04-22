// ignore_for_file: non_constant_identifier_names

import 'package:cocomu/app/failures/failure.dart';
import 'package:cocomu/data/entity/user_entity.dart';
import 'package:cocomu/data/providers/supabase_provider.dart';
import 'package:cocomu/data/sources/interfaces/user_data_source.dart';
import 'package:cocomu/domain/model/user.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

String TABLE = 'users';

class UserDatasourceIml implements UserDatasource {
  SupabaseProvider provider = Get.find();

  @override
  Future<Either<Failure, UserModel>> getUser(String id) async {
    try {
      final response =
          await provider.client.from(TABLE).select('*').eq('id', id).single();

      UserModel result = UserEntity.fromJson(response).toModel();

      return Right(result);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> loginWithApple() async {
    try {
      final response = await provider.client.auth.signInWithOAuth(
        OAuthProvider.apple,
      );

      return Right(response);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> loginWithKakao() async {
    try {
      final response = await provider.client.auth.signInWithOAuth(
        OAuthProvider.kakao,
      );

      return Right(response);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      await provider.client.auth.signOut();
      return const Right(true);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Stream<User?> subscribeUser() {
    return provider.client.auth.onAuthStateChange.map((event) {
      User? user = event.session?.user;
      return user;
    });
  }
}
