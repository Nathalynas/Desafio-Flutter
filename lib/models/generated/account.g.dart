// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PermissionDataImpl _$$PermissionDataImplFromJson(Map<String, dynamic> json) =>
    _$PermissionDataImpl(
      permission: $enumDecode(_$AccountPermissionEnumMap, json['permission']),
      ptBr: json['pt_br'] as String,
    );

Map<String, dynamic> _$$PermissionDataImplToJson(
        _$PermissionDataImpl instance) =>
    <String, dynamic>{
      'permission': _$AccountPermissionEnumMap[instance.permission]!,
      'pt_br': instance.ptBr,
    };

const _$AccountPermissionEnumMap = {
  AccountPermission.add_and_delete_products: 'add_and_delete_products',
  AccountPermission.account_management: 'account_management',
  AccountPermission.users: 'users',
};

_$AccountImpl _$$AccountImplFromJson(Map<String, dynamic> json) =>
    _$AccountImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      permissions: (json['permissions'] as List<dynamic>)
          .map((e) => PermissionData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$AccountImplToJson(_$AccountImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'permissions': instance.permissions.map((e) => e.toJson()).toList(),
    };
