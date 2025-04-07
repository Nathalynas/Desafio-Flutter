import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/profile.freezed.dart';
part 'generated/profile.g.dart';

@freezed
class ProfileData with _$ProfileData {
  const factory ProfileData({
    required String name,
    required String email,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'account_id') required int accountId,
  }) = _ProfileData;

  factory ProfileData.fromJson(Map<String, dynamic> json) =>
      _$ProfileDataFromJson(json);
}


