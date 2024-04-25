import 'package:zippy/domain/model/content.dart';
import 'package:zippy/domain/model/user_channel.dart';
import 'package:zippy/domain/repositories/interfaces/item_repository.dart';

class SubscribeItems {
  final ItemRepository repo;

  SubscribeItems(this.repo);

  Stream<List<Content>> execute(List<UserChannel> channels) {
    return repo.subscribeItems(channels);
  }
}
