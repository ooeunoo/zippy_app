import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/domain/model/channel.dart';
import 'package:zippy/domain/repositories/interfaces/channel_repository.dart';
import 'package:dartz/dartz.dart';

class GetChannels {
  final ChannelRepository repo;

  GetChannels(this.repo);

  Future<Either<Failure, List<Channel>>> execute() {
    return repo.getChannels();
  }
}
