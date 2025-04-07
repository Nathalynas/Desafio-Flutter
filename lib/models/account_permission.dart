enum AccountPermission {
  add_and_delete_products,
  account_management,
  users,
}

extension AccountPermissionExtension on AccountPermission {
  String get encoded => toString().split('.').last;
}

extension AccountPermissionListExtension on List<AccountPermission> {
  List<String> toJson() {
    return map((AccountPermission p) => p.encoded).toList();
  }
}
