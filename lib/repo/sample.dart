import 'model/model.dart';

class SampleRepository {
  final _items = [
    Item('login', kTypeLogin),
    Item('top', kTypeTop),
    Item('db_list', kTypeDbList),
    Item('grid', kTypeGrid),
  ];

  Future<List<Item>> list() {
    return Future.value(_items);
  }
}
