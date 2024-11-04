import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/providers/supabase.provider.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:zippy/domain/model/params/create_user_interaction.params.dart';
import 'package:zippy/domain/model/params/update_user_interaction.params.dart';

String TABLE = 'user_interactions';

abstract class UserInteractionDatasource {
  Future<Either<Failure, bool>> createUserInteraction(
      CreateUserInteractionParams params);
  Future<Either<Failure, bool>> updateUserInteraction(
      UpdateUserInteractionParams params);
}

class UserInteractionDatasourceImpl implements UserInteractionDatasource {
  SupabaseProvider provider = Get.find();

  @override
  Future<Either<Failure, bool>> createUserInteraction(
      CreateUserInteractionParams params) async {
    try {
      await provider.client.from(TABLE).upsert(params.toJson()).select('*');

      return const Right(true);
    } catch (e) {
      print('e: $e');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> updateUserInteraction(
      UpdateUserInteractionParams params) async {
    try {
      await provider.client
          .from(TABLE)
          .update(params.toJson())
          .eq('id', params.id)
          .select('*');
      return const Right(true);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
