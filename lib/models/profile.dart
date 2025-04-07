import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/profile.freezed.dart';
part 'generated/profile.g.dart';

@freezed
class ProfileData with _$ProfileData {
  const factory ProfileData({
    required String name,
    required String email,
  }) = _ProfileData;

  factory ProfileData.fromJson(Map<String, dynamic> json) =>
      _$ProfileDataFromJson(json);
}


