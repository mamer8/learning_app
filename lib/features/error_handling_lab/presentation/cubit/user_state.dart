import 'package:equatable/equatable.dart';
import '../../../../core/core.dart';
import '../../domain/entities/user_profile.dart';

/// الحالات المختلفة لواجهة المستخدم (Presentation States)
abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

/// الحالة الأولية عند فتح الشاشة
class UserInitial extends UserState {}

/// حالة تحميل البيانات (Loading)
class UserLoading extends UserState {}

/// حالة نجاح جلب البيانات (Success State)
class UserLoaded extends UserState {
  final UserProfile user;

  const UserLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

/// حالة فشل جلب البيانات مع نوع الفشل المحدد (Error State)
class UserError extends UserState {
  final Failure failure;

  const UserError(this.failure);

  @override
  List<Object?> get props => [failure];
}
