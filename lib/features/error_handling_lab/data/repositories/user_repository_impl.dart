import 'package:dartz/dartz.dart';
import '../../../../core/core.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/mock_user_remote_data_source.dart';

/// تنفيذ المستودع في طبقة الـ Data
/// وظيفته: التقاط الاستثناءات (Exceptions) القادمة من الـ Data Sources
/// وتحويلها إلى كائنات Failure مفهومة ومغلفة في `Either<Failure, UserProfile>`
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserProfile>> getUserProfile({
    required MockScenario scenario,
  }) async {
    try {
      final user = await remoteDataSource.fetchUserProfile(scenario);
      // إرجاع النتيجة الناجحة في الطرف الأيمن (Right)
      return Right(user);
    } on UnauthorizedException catch (e) {
      // إرجاع الفشل في الطرف الأيسر (Left)
      return Left(UnauthorizedFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on TimeoutExceptionCustom catch (e) {
      return Left(TimeoutFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: 'حدث خطأ غير متوقع: $e'));
    }
  }
}
