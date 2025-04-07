// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      permissions: (json['permissions'] as List<dynamic>)
          .map((e) => PermissionData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'password': instance.password,
      'permissions': instance.permissions.map((e) => e.toJson()).toList(),
    };
