import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/login.freezed.dart';
part 'generated/login.g.dart';

@Freezed()
class LoginData with _$LoginData {
  const factory LoginData({
    required String email,
    required String password,
  }) = _LoginData;

  factory LoginData.fromJson(Map<String, dynamic> json) =>
    _$LoginDataFromJson(json);
}