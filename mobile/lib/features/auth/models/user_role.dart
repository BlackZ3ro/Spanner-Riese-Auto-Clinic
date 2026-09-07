enum UserRole {
  admin,
  mechanic;

  String get displayName {
    switch (this) {
      case UserRole.admin:
        return 'Admin';
      case UserRole.mechanic:
        return 'Mechanic';
    }
  }
}