import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/entity/user_channel_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:zippy/domain/repositories/interfaces/user_channel_repository.dart';

class DeleteUserChannel {
  final UserChannelRepository repo;

  DeleteUserChannel(this.repo);

  Future<Either<Failure, bool>> execute(List<UserChannelEntity> channels) {
    return repo.deleteUserChannel(channels);
  }
}
