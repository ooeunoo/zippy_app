import 'package:cocomu/domain/model/item.dart';
import 'package:cocomu/domain/repositories/interfaces/item_repository.dart';

class SubscribeItems {
  final ItemRepository repo;

  SubscribeItems(this.repo);

  Stream<List<Item>> execute() {
    return repo.subscribeItems();
  }
}
