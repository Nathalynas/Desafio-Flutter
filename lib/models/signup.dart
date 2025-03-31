import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/signup.freezed.dart';
part 'generated/signup.g.dart';

@Freezed()
class SignupData with _$SignupData {
  const factory SignupData({
    required String name,
    required String email,
    required String password,
  }) = _SignupData;

  factory SignupData.fromJson(Map<String, dynamic> json) =>
      _$SignupDataFromJson(json);
}
