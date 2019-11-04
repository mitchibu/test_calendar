// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Calendar _$CalendarFromJson(Map<String, dynamic> json) {
  return Calendar(
      date: json['date'] as int,
      color: json['color'] as int,
      icons: (json['icons'] as List)?.map((e) => e as String)?.toList())
    ..memo = json['memo'] as String;
}

Map<String, dynamic> _$CalendarToJson(Calendar instance) => <String, dynamic>{
      'date': instance.date,
      'color': instance.color,
      'icons': instance.icons,
      'memo': instance.memo
    };

Shop _$ShopFromJson(Map<String, dynamic> json) {
  return Shop(json['name'] as String, json['price'] as int);
}

Map<String, dynamic> _$ShopToJson(Shop instance) =>
    <String, dynamic>{'name': instance.name, 'price': instance.price};
