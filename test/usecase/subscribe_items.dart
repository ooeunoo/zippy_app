import 'package:cocomu/data/sources/implementations/item_data_source_impl.dart';
import 'package:cocomu/data/sources/interfaces/item_data_source.dart';
import 'package:cocomu/domain/repositories/implementations/item_repository.dart';
import 'package:cocomu/domain/repositories/interfaces/item_repository.dart';
import 'package:cocomu/domain/usecases/subscirbe_items.dart';
import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/annotations.dart';

// import 'package:crm/domain/repositories/interfaces/customer_repository.dart';
// import 'package:crm/domain/use_cases/customer/get_all_customers.dart';

// import 'get_all_customers_test.mocks.dart';

// @GenerateMocks([CustomerRepository])
void main() {
  late SubscribeItems subscribeItems;
  late ItemRepositoryImpl itemRepository;
  late ItemDatasourceImpl itemDatasource;

  setUp(() {
    itemDatasource = ItemDatasourceImpl();
    itemRepository = ItemRepositoryImpl(itemDatasource);
    subscribeItems = SubscribeItems(itemRepository);
  });

  test("should get all customers from the customer repository", () async {
    subscribeItems.execute().listen((event) {
      print(event);
    });
  });
}
