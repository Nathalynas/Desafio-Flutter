// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

User _$UserFromJson(Map<String, dynamic> json) {
  return _User.fromJson(json);
}

/// @nodoc
mixin _$User {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;
  Map<String, dynamic> get permissions =>
      throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(name: 'account_id')
  int? get accountId => throw _privateConstructorUsedError;

  /// Serializes this User to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserCopyWith<User> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCopyWith<$Res> {
  factory $UserCopyWith(User value, $Res Function(User) then) =
      _$UserCopyWithImpl<$Res, User>;
  @useResult
  $Res call(
      {int id,
      String name,
      String email,
      String password,
      Map<String, dynamic> permissions,
      @JsonKey(name: 'account_id') int? accountId});
}

/// @nodoc
class _$UserCopyWithImpl<$Res, $Val extends User>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? email = null,
    Object? password = null,
    Object? permissions = null,
    Object? accountId = freezed,
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
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      permissions: null == permissions
          ? _value.permissions
          : permissions // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      accountId: freezed == accountId
          ? _value.accountId
          : accountId // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserImplCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$$UserImplCopyWith(
          _$UserImpl value, $Res Function(_$UserImpl) then) =
      __$$UserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String name,
      String email,
      String password,
      Map<String, dynamic> permissions,
      @JsonKey(name: 'account_id') int? accountId});
}

/// @nodoc
class __$$UserImplCopyWithImpl<$Res>
    extends _$UserCopyWithImpl<$Res, _$UserImpl>
    implements _$$UserImplCopyWith<$Res> {
  __$$UserImplCopyWithImpl(_$UserImpl _value, $Res Function(_$UserImpl) _then)
      : super(_value, _then);

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? email = null,
    Object? password = null,
    Object? permissions = null,
    Object? accountId = freezed,
  }) {
    return _then(_$UserImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      permissions: null == permissions
          ? _value._permissions
          : permissions // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      accountId: freezed == accountId
          ? _value.accountId
          : accountId // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserImpl implements _User {
  _$UserImpl(
      {required this.id,
      required this.name,
      required this.email,
      required this.password,
      required final Map<String, dynamic> permissions,
      @JsonKey(name: 'account_id') required this.accountId})
      : _permissions = permissions;

  factory _$UserImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String email;
  @override
  final String password;
  final Map<String, dynamic> _permissions;
  @override
  Map<String, dynamic> get permissions {
    if (_permissions is EqualUnmodifiableMapView) return _permissions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_permissions);
  }

// ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'account_id')
  final int? accountId;

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, password: $password, permissions: $permissions, accountId: $accountId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password) &&
            const DeepCollectionEquality()
                .equals(other._permissions, _permissions) &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, email, password,
      const DeepCollectionEquality().hash(_permissions), accountId);

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      __$$UserImplCopyWithImpl<_$UserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserImplToJson(
      this,
    );
  }
}

abstract class _User implements User {
  factory _User(
      {required final int id,
      required final String name,
      required final String email,
      required final String password,
      required final Map<String, dynamic> permissions,
      @JsonKey(name: 'account_id') required final int? accountId}) = _$UserImpl;

  factory _User.fromJson(Map<String, dynamic> json) = _$UserImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String get email;
  @override
  String get password;
  @override
  Map<String, dynamic> get permissions; // ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'account_id')
  int? get accountId;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
