class User {
  final String id;
  final String name;
  final String role; // 'super_admin', 'admin', 'user'

  User({required this.id, required this.name, required this.role});

  bool get isAdmin => role == 'admin' || role == 'super_admin';
  bool get isSuperAdmin => role == 'super_admin';
  bool get isRegularUser => role == 'user';
}
