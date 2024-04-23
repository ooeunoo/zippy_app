import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/sources/interfaces/channel_data_source.dart';
import 'package:zippy/domain/model/channel.dart';
import 'package:zippy/domain/repositories/interfaces/channel_repository.dart';
import 'package:dartz/dartz.dart';

class ChannelRepositoryImpl implements ChannelRepository {
  final ChannelDatasource datasource;

  ChannelRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<Channel>>> getChannels() {
    return datasource.getChannels();
  }

  @override
  Future<Either<Failure, Channel>> getChannel(int id) {
    return datasource.getChannel(id);
  }
}
