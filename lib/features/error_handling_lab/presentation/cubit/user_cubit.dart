import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/user_repository.dart';
import 'user_state.dart';

/// كلاس إدارة الحالة [UserCubit]
/// يستقبل نتيجة الـ Repository كـ `Either<Failure, UserProfile>`
/// ويفكها وظيفياً باستخدام دالة `.fold()` بكل سلاسة ونظافة!
class UserCubit extends Cubit<UserState> {
  final UserRepository repository;

  UserCubit({required this.repository}) : super(UserInitial());

  /// تنفيذ الطلب مع التعامل مع النجاح والفشل عبر .fold()
  Future<void> fetchUser(MockScenario scenario) async {
    emit(UserLoading());

    final result = await repository.getUserProfile(scenario: scenario);

    // دالة fold تأخذ معالجين:
    // الأول للجانب الأيسر (Left - Failure)
    // والثاني للجانب الأيمن (Right - Success)
    result.fold(
      (failure) {
        // حالة الفشل
        emit(UserError(failure));
      },
      (userProfile) {
        // حالة النجاح
        emit(UserLoaded(userProfile));
      },
    );
  }

  void reset() {
    emit(UserInitial());
  }
}
