// ignore_for_file: non_constant_identifier_names

import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/entity/user_entity.dart';
import 'package:zippy/data/providers/supabase_provider.dart';
import 'package:zippy/data/sources/interfaces/user_data_source.dart';
import 'package:zippy/domain/model/user.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

String TABLE = 'user';

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
      if (e is AuthException) {
        String? code = e.statusCode;
        if (code == FailureCode.alreadyRegisteredUserEmailFailure.code) {
          return Left(AlreadyRegisteredUserEmailFailure());
        }
      }
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> loginWithGoogle() async {
    try {
      final response = await provider.client.auth.signInWithOAuth(
        OAuthProvider.google,
      );

      return Right(response);
    } catch (e) {
      if (e is AuthException) {
        String? code = e.statusCode;
        if (code == FailureCode.alreadyRegisteredUserEmailFailure.code) {
          return Left(AlreadyRegisteredUserEmailFailure());
        }
      }
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
      if (e is AuthException) {
        String? code = e.statusCode;
        if (code == FailureCode.alreadyRegisteredUserEmailFailure.code) {
          return Left(AlreadyRegisteredUserEmailFailure());
        }
      }
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> loginWithNaver() async {
    try {
      FlutterNaverLogin.logOut();
      NaverLoginResult result = await FlutterNaverLogin.logIn();
      String email = result.account.email;
      String id = result.account.id;
      String name = result.account.name;

      UserModel? user = await _isRegisteredUserByEmail(email);

      if (user != null) {
        if (user.provider != 'naver') {
          return Left(AlreadyRegisteredUserEmailFailure());
        }

        await provider.client.auth
            .signInWithPassword(email: email, password: id);
      } else {
        await provider.client.auth.signUp(email: email, password: id, data: {
          "name": name,
          "email": email,
          "full_name": name,
          "user_name": name,
          'preferred_username': name,
          'provider_id': "naver",
        });
      }

      return const Right(true);
    } catch (e) {
      if (e is AuthException) {
        String? code = e.statusCode;
        if (code == FailureCode.alreadyRegisteredUserEmailFailure.code) {
          return Left(AlreadyRegisteredUserEmailFailure());
        }
      }
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      await provider.client.auth.signOut();
      return const Right(true);
    } catch (e) {
      print(e);
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

  Future<UserModel?> _isRegisteredUserByEmail(String email) async {
    try {
      final response = await provider.client
          .from(TABLE)
          .select('*')
          .match({email: email}).single();

      UserModel result = UserEntity.fromJson(response).toModel();

      return result;
    } catch (e) {
      return null;
    }
  }

  _updateUserProvider() {}
}
