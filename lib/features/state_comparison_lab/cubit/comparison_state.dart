import 'package:equatable/equatable.dart';

/// حالة موحدة لمختبر مقارنة إدارة الحالة
class ComparisonState extends Equatable {
  final int counter;
  final String status;
  final String activeColorHex;
  final int lastUpdatedTimestamp;

  const ComparisonState({
    this.counter = 0,
    this.status = 'Idle',
    this.activeColorHex = '14B8A6',
    this.lastUpdatedTimestamp = 0,
  });

  ComparisonState copyWith({
    int? counter,
    String? status,
    String? activeColorHex,
    int? lastUpdatedTimestamp,
  }) {
    return ComparisonState(
      counter: counter ?? this.counter,
      status: status ?? this.status,
      activeColorHex: activeColorHex ?? this.activeColorHex,
      lastUpdatedTimestamp:
          lastUpdatedTimestamp ?? this.lastUpdatedTimestamp,
    );
  }

  @override
  List<Object?> get props => [
        counter,
        status,
        activeColorHex,
        lastUpdatedTimestamp,
      ];
}
