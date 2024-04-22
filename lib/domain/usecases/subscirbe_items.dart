import 'package:zippy/domain/model/item.dart';
import 'package:zippy/domain/repositories/interfaces/item_repository.dart';

class SubscribeItems {
  final ItemRepository repo;

  SubscribeItems(this.repo);

  Stream<List<Item>> execute() {
    return repo.subscribeItems();
  }
}
