import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';

class DayInfo {
  var isHover = false;
  var color = 0;
  var icons = List<String>();
}

const kTypeTop = 0;
const kTypeLogin = 1;
const kTypeDbList = 2;
const kTypeGrid = 3;

class Item {
  Item(this.title, this.type);

  final String title;
  final int type;
}

@JsonSerializable()
class Shop {
  @JsonKey(ignore: true)
  int id;
  String name;
  int price;
  Shop(this.name, this.price);

  factory Shop.fromJson(Map<String, dynamic> json) => _$ShopFromJson(json);
  Map<String, dynamic> toJson() => _$ShopToJson(this);
}
