enum DatabaseEngine {
  drift,
  sqflite,
  hive,
}

class DbRecord {
  final int id;
  final String title;
  final String category;
  final double amount;
  final String status;
  final int timestamp;
  final bool isSynced;

  const DbRecord({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.status,
    required this.timestamp,
    required this.isSynced,
  });

  DbRecord copyWith({
    int? id,
    String? title,
    String? category,
    double? amount,
    String? status,
    int? timestamp,
    bool? isSynced,
  }) {
    return DbRecord(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}

class OutboxSyncItem {
  final String operationId;
  final String action; // INSERT, UPDATE, DELETE
  final String payload;
  final int retryCount;
  final String status; // PENDING, SYNCING, COMPLETED

  const OutboxSyncItem({
    required this.operationId,
    required this.action,
    required this.payload,
    required this.retryCount,
    required this.status,
  });
}
