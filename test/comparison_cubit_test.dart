import 'package:flutter_test/flutter_test.dart';
import 'package:learning/features/state_comparison_lab/cubit/comparison_cubit.dart';
import 'package:learning/features/state_comparison_lab/cubit/comparison_state.dart';

void main() {
  group('ComparisonCubit Unit & Stream Tests', () {
    late ComparisonCubit cubit;

    setUp(() {
      cubit = ComparisonCubit();
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state has default values', () {
      expect(cubit.state, equals(const ComparisonState()));
      expect(cubit.state.counter, 0);
      expect(cubit.state.status, 'Idle');
      expect(cubit.state.activeColorHex, '14B8A6');
    });

    test('incrementCounter emits new state with counter + 1', () {
      expectLater(
        cubit.stream.map((s) => s.counter),
        emitsInOrder([1, 2]),
      );

      cubit.incrementCounter();
      cubit.incrementCounter();
    });

    test('updateStatus emits updated status string', () {
      expectLater(
        cubit.stream.map((s) => s.status),
        emitsInOrder(['Loading...', 'Synced']),
      );

      cubit.updateStatus('Loading...');
      cubit.updateStatus('Synced');
    });

    test('reset restores initial state values', () {
      cubit.incrementCounter();
      cubit.updateStatus('Custom');

      cubit.reset();

      expect(cubit.state.counter, 0);
      expect(cubit.state.status, 'Idle');
    });
  });
}
