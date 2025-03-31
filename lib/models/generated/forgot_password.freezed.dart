// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../forgot_password.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ForgotPasswordData _$ForgotPasswordDataFromJson(Map<String, dynamic> json) {
  return _ForgotPasswordData.fromJson(json);
}

/// @nodoc
mixin _$ForgotPasswordData {
  String get email => throw _privateConstructorUsedError;

  /// Serializes this ForgotPasswordData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ForgotPasswordData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ForgotPasswordDataCopyWith<ForgotPasswordData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ForgotPasswordDataCopyWith<$Res> {
  factory $ForgotPasswordDataCopyWith(
          ForgotPasswordData value, $Res Function(ForgotPasswordData) then) =
      _$ForgotPasswordDataCopyWithImpl<$Res, ForgotPasswordData>;
  @useResult
  $Res call({String email});
}

/// @nodoc
class _$ForgotPasswordDataCopyWithImpl<$Res, $Val extends ForgotPasswordData>
    implements $ForgotPasswordDataCopyWith<$Res> {
  _$ForgotPasswordDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ForgotPasswordData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
  }) {
    return _then(_value.copyWith(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ForgotPasswordDataImplCopyWith<$Res>
    implements $ForgotPasswordDataCopyWith<$Res> {
  factory _$$ForgotPasswordDataImplCopyWith(_$ForgotPasswordDataImpl value,
          $Res Function(_$ForgotPasswordDataImpl) then) =
      __$$ForgotPasswordDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String email});
}

/// @nodoc
class __$$ForgotPasswordDataImplCopyWithImpl<$Res>
    extends _$ForgotPasswordDataCopyWithImpl<$Res, _$ForgotPasswordDataImpl>
    implements _$$ForgotPasswordDataImplCopyWith<$Res> {
  __$$ForgotPasswordDataImplCopyWithImpl(_$ForgotPasswordDataImpl _value,
      $Res Function(_$ForgotPasswordDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of ForgotPasswordData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
  }) {
    return _then(_$ForgotPasswordDataImpl(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ForgotPasswordDataImpl implements _ForgotPasswordData {
  const _$ForgotPasswordDataImpl({required this.email});

  factory _$ForgotPasswordDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$ForgotPasswordDataImplFromJson(json);

  @override
  final String email;

  @override
  String toString() {
    return 'ForgotPasswordData(email: $email)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ForgotPasswordDataImpl &&
            (identical(other.email, email) || other.email == email));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, email);

  /// Create a copy of ForgotPasswordData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ForgotPasswordDataImplCopyWith<_$ForgotPasswordDataImpl> get copyWith =>
      __$$ForgotPasswordDataImplCopyWithImpl<_$ForgotPasswordDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ForgotPasswordDataImplToJson(
      this,
    );
  }
}

abstract class _ForgotPasswordData implements ForgotPasswordData {
  const factory _ForgotPasswordData({required final String email}) =
      _$ForgotPasswordDataImpl;

  factory _ForgotPasswordData.fromJson(Map<String, dynamic> json) =
      _$ForgotPasswordDataImpl.fromJson;

  @override
  String get email;

  /// Create a copy of ForgotPasswordData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ForgotPasswordDataImplCopyWith<_$ForgotPasswordDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
