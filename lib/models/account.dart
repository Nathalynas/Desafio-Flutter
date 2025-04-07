import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/account.freezed.dart';
part 'generated/account.g.dart';

@freezed
class Account with _$Account {
  const factory Account({
    required int id,
    required String name,
  }) = _Account;

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);
}
