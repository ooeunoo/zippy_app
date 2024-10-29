import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/providers/supabase.provider.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:zippy/domain/model/params/create_user_interaction.params.dart';

String TABLE = 'user_interactions';

abstract class UserInteractionDatasource {
  Future<Either<Failure, bool>> createUserInteraction(
      CreateUserInteractionParams params);
}

class UserInteractionDatasourceImpl implements UserInteractionDatasource {
  SupabaseProvider provider = Get.find();

  @override
  Future<Either<Failure, bool>> createUserInteraction(
      CreateUserInteractionParams params) async {
    try {
      await provider.client.from(TABLE).insert(params.toJson()).select('*');
      return const Right(true);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
