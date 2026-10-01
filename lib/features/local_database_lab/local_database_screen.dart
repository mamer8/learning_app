import 'package:flutter/material.dart';
import '../../core/core.dart';
import '../../core/localization/app_localizations.dart';
import '../ai_chat/widgets/contextual_ai_sheet.dart';
import '../quiz/lab_quiz_action.dart';
import 'models/db_record.dart';

/// مختبر قواعد البيانات المحلية والتخزين الذكي (Local Database & Cache Lab)
/// Drift vs SQFlite vs Hive vs Outbox Sync Pattern
class LocalDatabaseScreen extends StatefulWidget {
  const LocalDatabaseScreen({super.key});

  @override
  State<LocalDatabaseScreen> createState() => _LocalDatabaseScreenState();
}

class _LocalDatabaseScreenState extends State<LocalDatabaseScreen> {
  DatabaseEngine _selectedEngine = DatabaseEngine.drift;
  int _activeViewTab = 0; // 0: Live Table, 1: Outbox Queue, 2: Schema Inspector
  int _schemaVersion = 1;
  bool _hasLoyaltyColumn = false;
  String _lastLog = 'Database initialized in WAL (Write-Ahead Logging) mode.';
  int _lastExecutionMs = 2;

  final List<DbRecord> _records = [
    const DbRecord(
      id: 1,
      title: 'Subscription Pro Yearly',
      category: 'Billing',
      amount: 99.99,
      status: 'Paid',
      timestamp: 1727788800000,
      isSynced: true,
    ),
    const DbRecord(
      id: 2,
      title: 'Cloud Backup Storage 100GB',
      category: 'Storage',
      amount: 19.50,
      status: 'Active',
      timestamp: 1727792400000,
      isSynced: true,
    ),
    const DbRecord(
      id: 3,
      title: 'Flutter Master Course License',
      category: 'Education',
      amount: 49.00,
      status: 'Paid',
      timestamp: 1727796000000,
      isSynced: false,
    ),
  ];

  final List<OutboxSyncItem> _outboxQueue = [
    const OutboxSyncItem(
      operationId: 'op_84912',
      action: 'INSERT',
      payload: '{"id":3,"title":"Flutter Master Course License"}',
      retryCount: 0,
      status: 'PENDING',
    ),
  ];

  void _insertRecord() {
    final newId = _records.length + 1;
    final stopwatch = Stopwatch()..start();

    setState(() {
      _records.insert(
        0,
        DbRecord(
          id: newId,
          title: 'Order Item #$newId (Local ACID Commit)',
          category: 'Retail',
          amount: 25.0 + (newId * 5),
          status: 'Pending',
          timestamp: DateTime.now().millisecondsSinceEpoch,
          isSynced: false,
        ),
      );

      _outboxQueue.insert(
        0,
        OutboxSyncItem(
          operationId: 'op_${DateTime.now().millisecondsSinceEpoch % 100000}',
          action: 'INSERT',
          payload: '{"id":$newId,"title":"Order Item #$newId"}',
          retryCount: 0,
          status: 'PENDING',
        ),
      );

      stopwatch.stop();
      _lastExecutionMs = (stopwatch.elapsedMicroseconds / 1000).ceil().clamp(1, 10);
      _lastLog =
          'INSERT INTO orders (id, title, amount) VALUES ($newId, ...) committed in ${_lastExecutionMs}ms with Outbox entry.';
    });
  }

  void _batchInsert50Records() {
    final stopwatch = Stopwatch()..start();
    final startId = _records.length + 1;

    final newItems = List.generate(50, (i) {
      final id = startId + i;
      return DbRecord(
        id: id,
        title: 'Bulk Batch Item #$id',
        category: i % 2 == 0 ? 'Enterprise' : 'Cloud',
        amount: 15.0 + i,
        status: 'Committed',
        timestamp: DateTime.now().millisecondsSinceEpoch,
        isSynced: true,
      );
    });

    setState(() {
      _records.insertAll(0, newItems);
      stopwatch.stop();
      _lastExecutionMs = (stopwatch.elapsedMilliseconds).clamp(3, 40);
      _lastLog =
          'BATCH TRANSACTION: 50 records committed inside single db.transaction() in ${_lastExecutionMs}ms.';
    });
  }

  void _simulateAtomicTransaction() {
    showDialog(
      context: context,
      builder: (ctx) {
        final isArabic = AppLocaleScope.of(context).isArabic;
        return AlertDialog(
          backgroundColor: const Color(0xFF101828),
          title: Text(
            isArabic ? 'تجربة الـ Atomic Transaction' : 'ACID Transaction Demo',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Text(
            isArabic
                ? 'سيتم تنفيذ معاملة مالية من خطوتين (خصم رصيد المستخدم + إنشاء الفاتورة). سنقوم بمحاكاة حدوث خطأ في الخطوة الثانية للتأكد من حدوث Rollback كامل دون فقدان أي بيانات!'
                : 'Will execute a 2-step financial transaction. Step 2 will simulate a failure to verify automatic atomic rollback without corrupted partial writes.',
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(isArabic ? 'إلغاء' : 'Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
              onPressed: () {
                Navigator.pop(ctx);
                setState(() {
                  _lastExecutionMs = 4;
                  _lastLog =
                      'TRANSACTION ROLLBACK: Step 2 threw Exception("Network Timeout"). All changes reverted safely (ACID Atomicity guaranteed).';
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: const Color(0xFF991B1B),
                    content: Text(
                      isArabic
                          ? '✅ نجح التراجع (Rollback): لم يتم خصم أي رصيد بسبب فشل المعاملة الجزئية!'
                          : '✅ Safe Rollback: No partial state corrupted!',
                    ),
                  ),
                );
              },
              child: Text(
                isArabic ? 'تشغيل المعاملة ومحاكاة الخطأ' : 'Run Transaction with Error',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  void _executeSchemaMigration() {
    setState(() {
      if (_schemaVersion == 1) {
        _schemaVersion = 2;
        _hasLoyaltyColumn = true;
        _lastLog =
            'SCHEMA MIGRATION (v1 -> v2): ALTER TABLE orders ADD COLUMN loyalty_points INTEGER DEFAULT 0; Migration executed seamlessly in 3ms.';
      } else {
        _schemaVersion = 1;
        _hasLoyaltyColumn = false;
        _lastLog = 'Database schema reset to v1 baseline.';
      }
    });
  }

  void _syncOutboxQueue() {
    if (_outboxQueue.isEmpty) return;
    setState(() {
      final count = _outboxQueue.length;
      _outboxQueue.clear();
      for (int i = 0; i < _records.length; i++) {
        _records[i] = _records[i].copyWith(isSynced: true);
      }
      _lastLog = 'SYNC QUEUE DISPATCH: $count pending Outbox operations synced successfully with server.';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Color(0xFF065F46),
        content: Text('✅ تمت مزامنة كافة العمليات المعلقة في طابور الـ Outbox مع السيرفر!'),
      ),
    );
  }

  String _getCodeSnippet(DatabaseEngine engine) {
    switch (engine) {
      case DatabaseEngine.drift:
        return '''// === 1. Drift (Type-Safe Reactive SQLite ORM) ===
import 'package:drift/drift.dart';

class Orders extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 100)();
  RealColumn get amount => real()();
  TextColumn get category => text()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  IntColumn get loyaltyPoints => integer().withDefault(const Constant(0))();
}

@DriftDatabase(tables: [Orders])
class AppDatabase extends _\$AppDatabase {
  AppDatabase(QueryExecutor e) : super(e);
  @override
  int get schemaVersion => 2;

  // Migration Strategy:
  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      if (from == 1) {
        await m.addColumn(orders, orders.loyaltyPoints);
      }
    },
  );

  // Reactive Stream Query (Auto updates UI):
  Stream<List<Order>> watchAllOrders() => select(orders).watch();
}''';
      case DatabaseEngine.sqflite:
        return '''// === 2. SQFlite (Raw SQL & Direct SQLite Driver) ===
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Future<Database> initDb() async {
    final path = join(await getDatabasesPath(), 'app_database.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute(\'\'\'
          CREATE TABLE orders(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            amount REAL NOT NULL,
            category TEXT NOT NULL,
            is_synced INTEGER DEFAULT 0
          )
        \'\'\');
        // Index for sub-millisecond lookups:
        await db.execute('CREATE INDEX idx_orders_category ON orders(category);');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE orders ADD COLUMN loyalty_points INTEGER DEFAULT 0;');
        }
      },
    );
  }

  // Transaction with Auto-Rollback:
  static Future<void> transferFunds(Database db, int fromId, int toId, double amount) async {
    await db.transaction((txn) async {
      await txn.rawUpdate('UPDATE accounts SET balance = balance - ? WHERE id = ?', [amount, fromId]);
      await txn.rawUpdate('UPDATE accounts SET balance = balance + ? WHERE id = ?', [amount, toId]);
    });
  }
}''';
      case DatabaseEngine.hive:
        return '''// === 3. Hive / Isar (High-Performance NoSQL Key-Value Box) ===
import 'package:hive_flutter/hive_flutter.dart';

part 'order_model.g.dart';

@HiveType(typeId: 0)
class OrderModel extends HiveObject {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final double amount;
  @HiveField(3)
  final bool isSynced;

  OrderModel({required this.id, required this.title, required this.amount, this.isSynced = false});
}

// Open Box & Fast Read/Write in < 1ms:
Future<void> setupHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(OrderModelAdapter());
  final box = await Hive.openBox<OrderModel>('orders_box');

  // Ultra fast O(1) Key-Value Insert:
  await box.put(1, OrderModel(id: 1, title: 'Pro Plan', amount: 99.0));

  // Reactive ValueListenable:
  // ValueListenableBuilder(valueListenable: box.listenable(), ...);
}''';
    }
  }

  void _openAiCopilot(BuildContext context, bool isArabic) {
    ContextualAiSheet.show(
      context,
      topicTitle: isArabic
          ? 'مختبر قواعد البيانات المحلية وهندسة التخزين'
          : 'Local Database Architecture Lab (Drift, SQFlite, Hive)',
      topicCode: _getCodeSnippet(_selectedEngine),
      levelTitle: isArabic
          ? 'المعاملات المالية ACID، الترقية والـ Migrations، وطابور Outbox Sync'
          : 'ACID Transactions, Migrations, Indexing & Outbox Sync Queue',
      isArabic: isArabic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocaleScope.of(context);
    final isArabic = locale.isArabic;

    return Directionality(
      textDirection: locale.textDirection,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            isArabic
                ? 'مختبر قواعد البيانات المحلية'
                : 'Local Database & Storage Lab',
          ),
          actions: [
            const LabQuizAction(labId: 'local-database'),
            IconButton(
              tooltip: isArabic ? 'اسأل المساعد الذكي' : 'Ask AI Copilot',
              icon: const Icon(Icons.psychology_rounded,
                  color: Color(0xFF14B8A6)),
              onPressed: () => _openAiCopilot(context, isArabic),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _openAiCopilot(context, isArabic),
          icon: const Icon(Icons.psychology_rounded, color: Color(0xFF04111C)),
          label: Text(
            isArabic
                ? 'استشر AI حول اختيار الـ Database لمشروعك'
                : 'Ask AI Best DB Architecture',
            style: const TextStyle(
                color: Color(0xFF04111C), fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color(0xFF14B8A6),
        ),
        body: ResponsiveContentWrapper(
          maxWidth: 1200,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
            children: [
              // 1. مقدمة هندسية
              _buildIntroCard(isArabic),
              14.heightBox,

              // 2. شريط اختيار المحرك (Drift / SQFlite / Hive)
              _buildEngineSelector(isArabic),
              14.heightBox,

              // 3. شريط إحصائيات قاعدة البيانات (Status & WAL Mode)
              _buildDbStatsBar(isArabic),
              14.heightBox,

              // 4. أزرار التحكم والعمليات (Operations Toolbar)
              _buildOperationsToolbar(isArabic),
              14.heightBox,

              // 5. سجل الأحداث وسرعة التنفيذ اللحظية
              _buildLiveLogTerminal(isArabic),
              16.heightBox,

              // 6. التبويبات (جدول البيانات / طابور الـ Outbox / الفهرس)
              _buildDataViewSection(isArabic),
              16.heightBox,

              // 7. جدول المفاضلة والمقارنة بين المحركات
              _buildComparisonMatrix(isArabic),
              16.heightBox,

              // 8. كود التنفيذ المصدري
              _buildCodeSection(isArabic),
              24.heightBox,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIntroCard(bool isArabic) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF101828),
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: const Color(0xFF0284C7).withValues(alpha: 0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF0284C7).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.storage_rounded,
                color: Color(0xFF38BDF8), size: 26),
          ),
          12.widthBox,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isArabic
                      ? 'قواعد البيانات المحلية وهندسة التخزين في Flutter'
                      : 'Local Database & Offline Storage Engineering',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.white),
                ),
                4.heightBox,
                Text(
                  isArabic
                      ? 'اختر بين Drift (Type-Safe SQL)، SQFlite (Raw SQLite)، أو Hive (NoSQL Key-Value). تعلم كيفية تطبيق المعاملات الآمنة (ACID Transactions)، والترقيات (Migrations)، ونمط طابور العمليات المعلقة (Outbox Sync Queue).'
                      : 'Master Drift type-safe ORM, SQFlite raw SQL, and Hive binary boxes. Explore ACID transactions, schema migrations, and outbox sync queues.',
                  style: const TextStyle(
                      fontSize: 12, color: Colors.white70, height: 1.45),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEngineSelector(bool isArabic) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildEngineTab(
              title: 'Drift (ORM)',
              subtitle: isArabic ? 'Type-Safe Reactive SQL' : 'Type-Safe Reactive',
              engine: DatabaseEngine.drift,
              accentColor: const Color(0xFF38BDF8),
            ),
          ),
          4.widthBox,
          Expanded(
            child: _buildEngineTab(
              title: 'SQFlite',
              subtitle: isArabic ? 'Raw SQLite & ACID' : 'Direct SQLite Driver',
              engine: DatabaseEngine.sqflite,
              accentColor: const Color(0xFF10B981),
            ),
          ),
          4.widthBox,
          Expanded(
            child: _buildEngineTab(
              title: 'Hive / Isar',
              subtitle: isArabic ? 'Binary Key-Value' : 'NoSQL Box Storage',
              engine: DatabaseEngine.hive,
              accentColor: const Color(0xFFF59E0B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEngineTab({
    required String title,
    required String subtitle,
    required DatabaseEngine engine,
    required Color accentColor,
  }) {
    final isSelected = _selectedEngine == engine;
    return InkWell(
      onTap: () => setState(() => _selectedEngine = engine),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1E293B) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isSelected ? Border.all(color: accentColor, width: 1.5) : null,
        ),
        child: Column(
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: isSelected ? Colors.white : Colors.white60,
              ),
            ),
            2.heightBox,
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? accentColor : Colors.white38,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDbStatsBar(bool isArabic) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF101828),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF24324A)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            label: isArabic ? 'إجمالي السجلات' : 'Total Rows',
            value: '${_records.length}',
            icon: Icons.table_rows_rounded,
            color: const Color(0xFF38BDF8),
          ),
          _buildStatItem(
            label: isArabic ? 'إصدار الـ Schema' : 'Schema Version',
            value: 'v$_schemaVersion ${_hasLoyaltyColumn ? "(+Loyalty)" : ""}',
            icon: Icons.alt_route_rounded,
            color: const Color(0xFFF59E0B),
          ),
          _buildStatItem(
            label: isArabic ? 'طابور الـ Outbox' : 'Outbox Queue',
            value: '${_outboxQueue.length} Pending',
            icon: Icons.cloud_queue_rounded,
            color: _outboxQueue.isEmpty
                ? const Color(0xFF10B981)
                : const Color(0xFFEF4444),
          ),
          _buildStatItem(
            label: isArabic ? 'وضع التسجيل' : 'Journal Mode',
            value: 'WAL Enabled',
            icon: Icons.speed_rounded,
            color: const Color(0xFF14B8A6),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        6.widthBox,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(fontSize: 10, color: Colors.white54)),
            Text(
              value,
              style: TextStyle(
                  fontSize: 11, fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOperationsToolbar(bool isArabic) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF101828),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF24324A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isArabic
                ? '⚡ عمليات وتجارب قاعدة البيانات التفاعلية:'
                : '⚡ Database Interactive Operations:',
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.white),
          ),
          12.heightBox,
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0284C7),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                onPressed: _insertRecord,
                icon: const Icon(Icons.add_circle_outline_rounded,
                    size: 16, color: Colors.white),
                label: Text(
                  isArabic ? 'إدراج سجل فردي (INSERT)' : 'Single Insert (ACID)',
                  style: const TextStyle(color: Colors.white, fontSize: 11),
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                onPressed: _batchInsert50Records,
                icon: const Icon(Icons.playlist_add_check_circle_rounded,
                    size: 16, color: Colors.white),
                label: Text(
                  isArabic ? 'إدراج 50 سجل في Batch واحد' : 'Batch Insert (50 Rows)',
                  style: const TextStyle(color: Colors.white, fontSize: 11),
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEF4444),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                onPressed: _simulateAtomicTransaction,
                icon: const Icon(Icons.security_rounded,
                    size: 16, color: Colors.white),
                label: Text(
                  isArabic
                      ? 'تجربة Transaction مع Rollback'
                      : 'Atomic Transaction & Rollback',
                  style: const TextStyle(color: Colors.white, fontSize: 11),
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B5CF6),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                onPressed: _executeSchemaMigration,
                icon: const Icon(Icons.upgrade_rounded,
                    size: 16, color: Colors.white),
                label: Text(
                  isArabic
                      ? 'ترقية الـ Schema (v$_schemaVersion -> v${_schemaVersion == 1 ? 2 : 1})'
                      : 'Schema Migration (v$_schemaVersion)',
                  style: const TextStyle(color: Colors.white, fontSize: 11),
                ),
              ),
              if (_outboxQueue.isNotEmpty)
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD97706),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                  ),
                  onPressed: _syncOutboxQueue,
                  icon: const Icon(Icons.sync_rounded,
                      size: 16, color: Colors.white),
                  label: Text(
                    isArabic
                        ? 'مزامنة الـ Outbox مع السيرفر (${_outboxQueue.length})'
                        : 'Dispatch Outbox (${_outboxQueue.length})',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLiveLogTerminal(bool isArabic) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0B1120),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.terminal_rounded,
              color: Color(0xFF10B981), size: 18),
          8.widthBox,
          Expanded(
            child: Text(
              _lastLog,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 11,
                color: Color(0xFF6EE7B7),
                height: 1.4,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0x3338BDF8),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '${_lastExecutionMs}ms',
              style: const TextStyle(
                  color: Color(0xFF38BDF8),
                  fontSize: 10,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataViewSection(bool isArabic) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF101828),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF24324A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _buildViewTabButton(
                    title: isArabic ? 'جدول الطلبات (Orders Table)' : 'Orders Table',
                    icon: Icons.storage_rounded,
                    tabIndex: 0,
                  ),
                  8.widthBox,
                  _buildViewTabButton(
                    title: isArabic
                        ? 'طابور المزامنة (Outbox Queue: ${_outboxQueue.length})'
                        : 'Outbox (${_outboxQueue.length})',
                    icon: Icons.cloud_sync_rounded,
                    tabIndex: 1,
                  ),
                ],
              ),
            ],
          ),
          12.heightBox,
          if (_activeViewTab == 0)
            _buildRecordsTable(isArabic)
          else
            _buildOutboxTable(isArabic),
        ],
      ),
    );
  }

  Widget _buildViewTabButton({
    required String title,
    required IconData icon,
    required int tabIndex,
  }) {
    final isSelected = _activeViewTab == tabIndex;
    return InkWell(
      onTap: () => setState(() => _activeViewTab = tabIndex),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1E293B) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isSelected
              ? Border.all(color: const Color(0xFF14B8A6))
              : Border.all(color: Colors.transparent),
        ),
        child: Row(
          children: [
            Icon(icon,
                size: 14,
                color: isSelected ? const Color(0xFF14B8A6) : Colors.white60),
            6.widthBox,
            Text(
              title,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.white : Colors.white60,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordsTable(bool isArabic) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(const Color(0xFF1E293B)),
        dataRowColor: WidgetStateProperty.all(const Color(0xFF0F172A)),
        border: TableBorder.all(
            color: const Color(0xFF334155),
            borderRadius: BorderRadius.circular(8)),
        columns: [
          const DataColumn(
              label: Text('ID (PK)',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white))),
          DataColumn(
              label: Text(isArabic ? 'العنوان' : 'Title',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white))),
          DataColumn(
              label: Text(isArabic ? 'التصنيف (Indexed)' : 'Category (Index)',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white))),
          DataColumn(
              label: Text(isArabic ? 'المبلغ' : 'Amount',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white))),
          if (_hasLoyaltyColumn)
            const DataColumn(
                label: Text('Loyalty Points (v2)',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF59E0B)))),
          DataColumn(
              label: Text(isArabic ? 'حالة التزامن' : 'Sync Status',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white))),
        ],
        rows: _records.take(8).map((record) {
          return DataRow(cells: [
            DataCell(Text('#${record.id}',
                style: const TextStyle(
                    color: Color(0xFF38BDF8), fontWeight: FontWeight.bold))),
            DataCell(Text(record.title,
                style: const TextStyle(color: Colors.white))),
            DataCell(Text(record.category,
                style: const TextStyle(color: Colors.white70))),
            DataCell(Text('\$${record.amount.toStringAsFixed(2)}',
                style: const TextStyle(
                    color: Color(0xFF10B981), fontWeight: FontWeight.bold))),
            if (_hasLoyaltyColumn)
              DataCell(Text('${record.id * 10} pts',
                  style: const TextStyle(color: Color(0xFFF59E0B)))),
            DataCell(
              Row(
                children: [
                  Icon(
                    record.isSynced
                        ? Icons.check_circle_rounded
                        : Icons.pending_rounded,
                    size: 14,
                    color: record.isSynced
                        ? const Color(0xFF10B981)
                        : const Color(0xFFF59E0B),
                  ),
                  4.widthBox,
                  Text(
                    record.isSynced ? 'Synced' : 'Pending',
                    style: TextStyle(
                      fontSize: 11,
                      color: record.isSynced
                          ? const Color(0xFF6EE7B7)
                          : const Color(0xFFFDE68A),
                    ),
                  ),
                ],
              ),
            ),
          ]);
        }).toList(),
      ),
    );
  }

  Widget _buildOutboxTable(bool isArabic) {
    if (_outboxQueue.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        alignment: Alignment.center,
        child: Column(
          children: [
            const Icon(Icons.check_circle_outline_rounded,
                color: Color(0xFF10B981), size: 36),
            8.heightBox,
            Text(
              isArabic
                  ? 'طابور الـ Outbox فارغ! جميع العمليات متزامنة بنجاح مع السيرفر.'
                  : 'Outbox queue is empty. All local operations synced!',
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      );
    }

    return Column(
      children: _outboxQueue.map((item) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF334155)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF0284C7).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  item.action,
                  style: const TextStyle(
                      color: Color(0xFF38BDF8),
                      fontWeight: FontWeight.bold,
                      fontSize: 11),
                ),
              ),
              10.widthBox,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.operationId,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold)),
                    2.heightBox,
                    Text(item.payload,
                        style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 10,
                            fontFamily: 'monospace')),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  item.status,
                  style: const TextStyle(
                      color: Color(0xFFF59E0B),
                      fontWeight: FontWeight.bold,
                      fontSize: 10),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildComparisonMatrix(bool isArabic) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF101828),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF24324A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isArabic
                ? '🧭 جدول مقارنة محركات قواعد البيانات في Flutter:'
                : '🧭 Database Engine Decision Matrix:',
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.white),
          ),
          12.heightBox,
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(const Color(0xFF1E293B)),
              dataRowColor: WidgetStateProperty.all(const Color(0xFF0F172A)),
              border: TableBorder.all(
                  color: const Color(0xFF334155),
                  borderRadius: BorderRadius.circular(8)),
              columns: [
                DataColumn(
                    label: Text(isArabic ? 'المحرك' : 'Engine',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white))),
                DataColumn(
                    label: Text(isArabic ? 'النوع' : 'Type',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white))),
                DataColumn(
                    label: Text(isArabic ? 'سرعة القراءة/الكتابة' : 'R/W Speed',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white))),
                DataColumn(
                    label: Text(isArabic ? 'دعم ACID و Transactions' : 'ACID & Relations',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white))),
                DataColumn(
                    label: Text(isArabic ? 'الاستخدام الأمثل' : 'Best For',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white))),
              ],
              rows: [
                DataRow(cells: [
                  const DataCell(Text('Drift',
                      style: TextStyle(
                          color: Color(0xFF38BDF8),
                          fontWeight: FontWeight.bold))),
                  const DataCell(Text('Type-Safe SQL ORM',
                      style: TextStyle(color: Colors.white70))),
                  const DataCell(Text('فائقة مع WAL Mode',
                      style: TextStyle(color: Colors.white70))),
                  const DataCell(Text('كامل 100% (Foreign Keys & Streams)',
                      style: TextStyle(color: Color(0xFF10B981)))),
                  DataCell(Text(isArabic ? 'تطبيقات المؤسسات الكبيرة والعلاقات المعقدة' : 'Complex relational enterprise apps',
                      style: const TextStyle(color: Colors.white70))),
                ]),
                DataRow(cells: [
                  const DataCell(Text('SQFlite',
                      style: TextStyle(
                          color: Color(0xFF10B981),
                          fontWeight: FontWeight.bold))),
                  const DataCell(Text('Raw SQLite C Bridge',
                      style: TextStyle(color: Colors.white70))),
                  const DataCell(Text('ممتازة جداً',
                      style: TextStyle(color: Colors.white70))),
                  const DataCell(Text('كامل 100% عبر SQL Queries',
                      style: TextStyle(color: Color(0xFF10B981)))),
                  DataCell(Text(isArabic ? 'المشاريع التي تحتاج SQL مباشر بدون CodeGen' : 'Direct SQL queries without generators',
                      style: const TextStyle(color: Colors.white70))),
                ]),
                DataRow(cells: [
                  const DataCell(Text('Hive / Isar',
                      style: TextStyle(
                          color: Color(0xFFF59E0B),
                          fontWeight: FontWeight.bold))),
                  const DataCell(Text('NoSQL Binary Box',
                      style: TextStyle(color: Colors.white70))),
                  const DataCell(Text('الأسرع على الإطلاق (O(1))',
                      style: TextStyle(color: Color(0xFF10B981)))),
                  DataCell(Text(isArabic ? 'محدود (بدون علاقات Relational)' : 'Limited (No SQL Relations)',
                      style: const TextStyle(color: Color(0xFFEF4444)))),
                  DataCell(Text(isArabic ? 'التخزين المؤقت (Cache) وجلسات المستخدم' : 'Caching, fast offline documents, settings',
                      style: const TextStyle(color: Colors.white70))),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeSection(bool isArabic) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF101828),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF24324A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isArabic
                    ? '💻 كود الإعداد والعمليات البرمجية:'
                    : '💻 Source Implementation Code:',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.white),
              ),
              Text(
                _selectedEngine.name.toUpperCase(),
                style: const TextStyle(
                    color: Color(0xFF14B8A6),
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
              ),
            ],
          ),
          10.heightBox,
          CopyableCodeBlock(
            code: _getCodeSnippet(_selectedEngine),
          ),
        ],
      ),
    );
  }
}
