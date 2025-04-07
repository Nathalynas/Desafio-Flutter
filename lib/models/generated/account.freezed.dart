// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../account.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PermissionData _$PermissionDataFromJson(Map<String, dynamic> json) {
  return _PermissionData.fromJson(json);
}

/// @nodoc
mixin _$PermissionData {
  AccountPermission get permission => throw _privateConstructorUsedError;
  String get ptBr => throw _privateConstructorUsedError;

  /// Serializes this PermissionData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PermissionData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PermissionDataCopyWith<PermissionData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PermissionDataCopyWith<$Res> {
  factory $PermissionDataCopyWith(
          PermissionData value, $Res Function(PermissionData) then) =
      _$PermissionDataCopyWithImpl<$Res, PermissionData>;
  @useResult
  $Res call({AccountPermission permission, String ptBr});
}

/// @nodoc
class _$PermissionDataCopyWithImpl<$Res, $Val extends PermissionData>
    implements $PermissionDataCopyWith<$Res> {
  _$PermissionDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PermissionData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? permission = null,
    Object? ptBr = null,
  }) {
    return _then(_value.copyWith(
      permission: null == permission
          ? _value.permission
          : permission // ignore: cast_nullable_to_non_nullable
              as AccountPermission,
      ptBr: null == ptBr
          ? _value.ptBr
          : ptBr // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PermissionDataImplCopyWith<$Res>
    implements $PermissionDataCopyWith<$Res> {
  factory _$$PermissionDataImplCopyWith(_$PermissionDataImpl value,
          $Res Function(_$PermissionDataImpl) then) =
      __$$PermissionDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({AccountPermission permission, String ptBr});
}

/// @nodoc
class __$$PermissionDataImplCopyWithImpl<$Res>
    extends _$PermissionDataCopyWithImpl<$Res, _$PermissionDataImpl>
    implements _$$PermissionDataImplCopyWith<$Res> {
  __$$PermissionDataImplCopyWithImpl(
      _$PermissionDataImpl _value, $Res Function(_$PermissionDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of PermissionData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? permission = null,
    Object? ptBr = null,
  }) {
    return _then(_$PermissionDataImpl(
      permission: null == permission
          ? _value.permission
          : permission // ignore: cast_nullable_to_non_nullable
              as AccountPermission,
      ptBr: null == ptBr
          ? _value.ptBr
          : ptBr // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PermissionDataImpl implements _PermissionData {
  const _$PermissionDataImpl({required this.permission, required this.ptBr});

  factory _$PermissionDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$PermissionDataImplFromJson(json);

  @override
  final AccountPermission permission;
  @override
  final String ptBr;

  @override
  String toString() {
    return 'PermissionData(permission: $permission, ptBr: $ptBr)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PermissionDataImpl &&
            (identical(other.permission, permission) ||
                other.permission == permission) &&
            (identical(other.ptBr, ptBr) || other.ptBr == ptBr));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, permission, ptBr);

  /// Create a copy of PermissionData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PermissionDataImplCopyWith<_$PermissionDataImpl> get copyWith =>
      __$$PermissionDataImplCopyWithImpl<_$PermissionDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PermissionDataImplToJson(
      this,
    );
  }
}

abstract class _PermissionData implements PermissionData {
  const factory _PermissionData(
      {required final AccountPermission permission,
      required final String ptBr}) = _$PermissionDataImpl;

  factory _PermissionData.fromJson(Map<String, dynamic> json) =
      _$PermissionDataImpl.fromJson;

  @override
  AccountPermission get permission;
  @override
  String get ptBr;

  /// Create a copy of PermissionData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PermissionDataImplCopyWith<_$PermissionDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Account _$AccountFromJson(Map<String, dynamic> json) {
  return _Account.fromJson(json);
}

/// @nodoc
mixin _$Account {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  List<PermissionData> get permissions => throw _privateConstructorUsedError;

  /// Serializes this Account to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Account
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AccountCopyWith<Account> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccountCopyWith<$Res> {
  factory $AccountCopyWith(Account value, $Res Function(Account) then) =
      _$AccountCopyWithImpl<$Res, Account>;
  @useResult
  $Res call({int id, String name, List<PermissionData> permissions});
}

/// @nodoc
class _$AccountCopyWithImpl<$Res, $Val extends Account>
    implements $AccountCopyWith<$Res> {
  _$AccountCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Account
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? permissions = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      permissions: null == permissions
          ? _value.permissions
          : permissions // ignore: cast_nullable_to_non_nullable
              as List<PermissionData>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AccountImplCopyWith<$Res> implements $AccountCopyWith<$Res> {
  factory _$$AccountImplCopyWith(
          _$AccountImpl value, $Res Function(_$AccountImpl) then) =
      __$$AccountImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String name, List<PermissionData> permissions});
}

/// @nodoc
class __$$AccountImplCopyWithImpl<$Res>
    extends _$AccountCopyWithImpl<$Res, _$AccountImpl>
    implements _$$AccountImplCopyWith<$Res> {
  __$$AccountImplCopyWithImpl(
      _$AccountImpl _value, $Res Function(_$AccountImpl) _then)
      : super(_value, _then);

  /// Create a copy of Account
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? permissions = null,
  }) {
    return _then(_$AccountImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      permissions: null == permissions
          ? _value._permissions
          : permissions // ignore: cast_nullable_to_non_nullable
              as List<PermissionData>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AccountImpl extends _Account {
  const _$AccountImpl(
      {required this.id,
      required this.name,
      required final List<PermissionData> permissions})
      : _permissions = permissions,
        super._();

  factory _$AccountImpl.fromJson(Map<String, dynamic> json) =>
      _$$AccountImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  final List<PermissionData> _permissions;
  @override
  List<PermissionData> get permissions {
    if (_permissions is EqualUnmodifiableListView) return _permissions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_permissions);
  }

  @override
  String toString() {
    return 'Account(id: $id, name: $name, permissions: $permissions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AccountImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality()
                .equals(other._permissions, _permissions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, name, const DeepCollectionEquality().hash(_permissions));

  /// Create a copy of Account
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AccountImplCopyWith<_$AccountImpl> get copyWith =>
      __$$AccountImplCopyWithImpl<_$AccountImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AccountImplToJson(
      this,
    );
  }
}

abstract class _Account extends Account {
  const factory _Account(
      {required final int id,
      required final String name,
      required final List<PermissionData> permissions}) = _$AccountImpl;
  const _Account._() : super._();

  factory _Account.fromJson(Map<String, dynamic> json) = _$AccountImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  List<PermissionData> get permissions;

  /// Create a copy of Account
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AccountImplCopyWith<_$AccountImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
