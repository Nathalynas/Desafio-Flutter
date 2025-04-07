// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductImpl _$$ProductImplFromJson(Map<String, dynamic> json) =>
    _$ProductImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      category: json['category_type'] as String,
      quantity: (json['quantity'] as num).toInt(),
      price: (json['value'] as num).toDouble(),
      url: json['url'] as String?,
      accountId: (json['account_id'] as num).toInt(),
    );

Map<String, dynamic> _$$ProductImplToJson(_$ProductImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'category_type': instance.category,
      'quantity': instance.quantity,
      'value': instance.price,
      if (instance.url case final value?) 'url': value,
      'account_id': instance.accountId,
    };
