import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/domain/model/user_channel.dart';
import 'package:dartz/dartz.dart';
import 'package:zippy/domain/repositories/interfaces/user_channel_repository.dart';

class GetUserChannelByUserId {
  final UserChannelRepository repo;

  GetUserChannelByUserId(this.repo);

  Future<Either<Failure, List<UserChannel>>> execute(String userId) {
    return repo.getUserChannelByUserId(userId);
  }
}
