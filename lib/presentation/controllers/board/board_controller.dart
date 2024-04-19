import 'package:cocomu/domain/model/item.dart';
import 'package:cocomu/domain/usecases/subscirbe_items.dart';
import 'package:get/get.dart';

class BoardController extends GetxController {
  final SubscribeItems subscribeItems;

  RxList<Item> subscribers = RxList<Item>([]).obs();

  BoardController(this.subscribeItems) {
    subscribers.bindStream(subscribe());
  }

  Stream<List<Item>> subscribe() {
    return subscribeItems.execute();
  }
}
