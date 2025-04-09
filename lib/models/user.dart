// ignore_for_file: invalid_annotation_target

import 'package:almeidatec/core/http_utils.dart';
import 'package:almeidatec/models/account.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/user.freezed.dart';
part 'generated/user.g.dart';

@freezed
class User with _$User {
  factory User({
    @JsonKey(name: 'user_id') required int id,
    required String name,
    required String email,
    @Default('') String? password,
    required List<PermissionData> permissions,
    @Default(true) bool isActive,
  }) = _User;

  factory User.fromJson(JSON json) => _$UserFromJson(json);
}
