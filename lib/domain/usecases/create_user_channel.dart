import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/entity/user_channel_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:zippy/domain/repositories/interfaces/user_channel_repository.dart';

class CreateUserChannel {
  final UserChannelRepository repo;

  CreateUserChannel(this.repo);

  Future<Either<Failure, bool>> execute(UserChannelEntity userChannel) {
    return repo.createUserChannel(userChannel);
  }
}
