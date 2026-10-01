import 'package:flutter_bloc/flutter_bloc.dart';
import 'comparison_state.dart';

/// Cubit لإدارة حالة المقارنة التفاعلية
class ComparisonCubit extends Cubit<ComparisonState> {
  ComparisonCubit() : super(const ComparisonState());

  void incrementCounter() {
    emit(state.copyWith(
      counter: state.counter + 1,
      lastUpdatedTimestamp: DateTime.now().millisecondsSinceEpoch,
    ));
  }

  void updateStatus(String newStatus) {
    emit(state.copyWith(
      status: newStatus,
      lastUpdatedTimestamp: DateTime.now().millisecondsSinceEpoch,
    ));
  }

  void changeColor(String colorHex) {
    emit(state.copyWith(
      activeColorHex: colorHex,
      lastUpdatedTimestamp: DateTime.now().millisecondsSinceEpoch,
    ));
  }

  void reset() {
    emit(const ComparisonState());
  }
}
