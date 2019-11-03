import 'dart:async';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

import 'model/model.dart';

class DatabaseRepository {
  Database _database;

  Future<Database> get _db async {
    if (_database == null) {
      var dir = await getApplicationDocumentsDirectory();
      await dir.create(recursive: true);
      var dbPath = join(dir.path, 'my_database.db');
      DatabaseFactory dbFactory = databaseFactoryIo;
      _database = await dbFactory.openDatabase(dbPath);
    }
    return _database;
  }

  Future<List<Calendar>> findCalendar(
      DateTime startDate, DateTime endDate) async {
    var list = List<Calendar>();
    var store = intMapStoreFactory.store('calendar');
    var records = await store.find(await _db,
        finder: Finder(
          filter: Filter.and([
            Filter.greaterThanOrEquals(
                'date', startDate.millisecondsSinceEpoch),
            Filter.lessThanOrEquals('date', endDate.millisecondsSinceEpoch)
          ]),
        ));
    records.forEach((record) {
      list.add(Calendar.fromJson(record.value)..id = record.key);
    });
    return list;
  }

  Future putCalendar(Calendar calendar) async {
    var store = intMapStoreFactory.store('calendar');
    if (calendar.id == null) {
      return store.add(await _db, calendar.toJson());
    } else {
      return store.record(calendar.id).put(await _db, calendar.toJson());
    }
  }
/*
  Future<List<Shop>> get fetch async {
    var list = List<Shop>();
    var store = intMapStoreFactory.store('shop');
    var records = await store.find(await _db);
    records.forEach((record) {
      list.add(Shop.fromJson(record.value)..id = record.key);
    });
    return list;
  }

  Future<Stream<List<Shop>>> stream() async {
    var store = intMapStoreFactory.store('shop');
    var query = store.query();
    return query.onSnapshots(await _db).map<List<Shop>>((records) {
      var list = List<Shop>();
      records.forEach((record) {
        list.add(Shop.fromJson(record.value)..id = record.key);
      });
      return list;
    });
  }

  Future add(Shop shop) async {
    var store = intMapStoreFactory.store('shop');
    return store.record(shop.id).add(await _db, shop.toJson());
  }

  Future remove(int id) async {
    var store = intMapStoreFactory.store('shop');
    return store.record(id).delete(await _db);
  }

  Future _test() async {
    var store = intMapStoreFactory.store('shop');
    int lampKey;
    int chairKey;
    var db = await _db;
    await db.transaction((txn) async {
      var lamp = {
        'name': 'Lamp',
        'price': 10,
      };
      lampKey = await store.add(txn, lamp);

      var chair = {
        'name': 'Chair',
        'price': 15,
      };
      chairKey = await store.add(txn, chair);
    });

    // update the price of the lamp record
    var lamp = {
      'price': 12,
    };
    await store.record(lampKey).update(db, lamp);
    // var records = await fetch;
    // records.forEach((record) {
    //   print(record.toString());
    // });
  }*/
}
