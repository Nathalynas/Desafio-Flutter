import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/forgot_password.freezed.dart';
part 'generated/forgot_password.g.dart';

@freezed
class ForgotPasswordData with _$ForgotPasswordData {
  const factory ForgotPasswordData({
    required String email,
  }) = _ForgotPasswordData;

  factory ForgotPasswordData.fromJson(Map<String, dynamic> json) =>
      _$ForgotPasswordDataFromJson(json);
}
