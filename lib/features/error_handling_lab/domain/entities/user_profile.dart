import 'package:equatable/equatable.dart';

/// كيان المستخدم (Domain Entity)
/// يمثل البيانات الصافية المستقلة عن أي إطار عمل أو مصدر بيانات خارجي
class UserProfile extends Equatable {
  final String id;
  final String name;
  final String email;
  final String role;
  final String avatarUrl;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.avatarUrl,
  });

  @override
  List<Object?> get props => [id, name, email, role, avatarUrl];
}
