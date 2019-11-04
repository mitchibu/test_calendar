import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';

@JsonSerializable()
class Calendar {
  Calendar({this.id, this.date, this.color, this.icons, this.memo});

  @JsonKey(ignore: true)
  int id;
  int date;
  int color;
  List<String> icons;
  String memo;

  factory Calendar.fromJson(Map<String, dynamic> json) =>
      _$CalendarFromJson(json);
  Map<String, dynamic> toJson() => _$CalendarToJson(this);
}

class DayInfo {
  int id;
  bool isHover = false;
  int color = 0;
  List<String> icons = List<String>();
  String memo;
}

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
