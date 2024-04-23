import 'package:zippy/domain/model/user_channel.dart';
import 'package:zippy/domain/repositories/interfaces/user_channel_repository.dart';

class SubscribeUserChannel {
  final UserChannelRepository repo;

  SubscribeUserChannel(this.repo);

  Stream<List<UserChannel>> execute(String userId) {
    return repo.subscribeUserChannel(userId);
  }
}
