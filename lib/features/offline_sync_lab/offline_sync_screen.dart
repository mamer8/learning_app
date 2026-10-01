import 'package:flutter/material.dart';
import '../../core/core.dart';
import '../ai_chat/widgets/contextual_ai_sheet.dart';
import '../quiz/lab_quiz_action.dart';

class _OfflineTask {
  final String id;
  final String title;
  bool isSynced;

  _OfflineTask({required this.id, required this.title, this.isSynced = false});
}

/// 🗄️ مختبر الـ Offline-First والتزامن والتحديث التفاؤلي (Optimistic UI)
class OfflineSyncScreen extends StatefulWidget {
  const OfflineSyncScreen({super.key});

  @override
  State<OfflineSyncScreen> createState() => _OfflineSyncScreenState();
}

class _OfflineSyncScreenState extends State<OfflineSyncScreen> {
  bool _isOnline = false;
  bool _isSyncing = false;
  final TextEditingController _taskController = TextEditingController();
  final List<_OfflineTask> _tasks = [
    _OfflineTask(
      id: '1',
      title: 'تجهيز ملف key.properties للإنتاج',
      isSynced: true,
    ),
    _OfflineTask(
      id: '2',
      title: 'فحص استهلاك الذاكرة بـ DevTools',
      isSynced: true,
    ),
  ];

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  void _openAiAssistant(int pendingCount) {
    ContextualAiSheet.show(
      context,
      topicTitle: 'مختبر الـ Offline-First والتزامن التفاؤلي',
      topicCode: _buildDynamicOfflineCode(pendingCount),
      levelTitle: 'مستوى متقدم (Senior Architecture & Caching)',
      isArabic: true,
    );
  }

  String _buildDynamicOfflineCode(int pendingCount) {
    return '// === Dynamic Offline Sync & Optimistic UI ===\n'
        '// حالة الشبكة الحالية: ${_isOnline ? "🟢 Online (متصل)" : "🔴 Offline (غير متصل)"}\n'
        '// عناصر في طابور المزامنة: $pendingCount معلقة | إجمالي المهام: ${_tasks.length}\n\n'
        'Future<void> addTask(Task task) async {\n'
        '  // 1. تحديث تفاؤلي فوري في الـ Local Cache (Hive/Drift)\n'
        '  final isConnected = $_isOnline;\n'
        '  final localTask = task.copyWith(isSynced: isConnected);\n'
        '  await localDataSource.saveTask(localTask);\n'
        '  emit(TaskLoaded(localDataSource.getAllTasks()));\n\n'
        '  // 2. طابور المزامنة التلقائي (Sync Queue Engine)\n'
        '  if (isConnected) {\n'
        '    // إرسال مباشر وفوري\n'
        '    await syncQueueWithServer(); // ${_isSyncing ? "جاري التزامن الآن..." : "متزامن"}\n'
        '  } else {\n'
        '    // إدراج المهمة في طابور الـ Pending (طابور العمليات المعلقة: $pendingCount)\n'
        '    syncQueue.enqueue(localTask.id);\n'
        '  }\n'
        '}';
  }

  void _addNewTask() {
    final text = _taskController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      // تحديث تفاؤلي: إضافة المهمة للواجهة فوراً
      _tasks.insert(
        0,
        _OfflineTask(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: text,
          isSynced:
              _isOnline, // لو أونلاين يتزامن فوراً، لو أوفلاين يدخل طابور الانتظار
        ),
      );
      _taskController.clear();
    });

    if (!_isOnline) {
      context.showInfoSnackBar(
        'أنت في وضع غير متصل (Offline). تمت إضافة المهمة محلياً في انتظار عودة الإنترنت!',
        title: 'حفظ محلي (Local Cache)',
      );
    } else {
      context.showSuccessSnackBar('تم إرسال المهمة وتزامنها مع السيرفر فوراً!');
    }
  }

  Future<void> _triggerSync() async {
    final unsynced = _tasks.where((t) => !t.isSynced).toList();
    if (unsynced.isEmpty) {
      context.showInfoSnackBar('جميع البيانات متزامنة مسبقاً!');
      return;
    }

    setState(() => _isSyncing = true);
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;

    setState(() {
      for (final t in _tasks) {
        t.isSynced = true;
      }
      _isSyncing = false;
    });

    context.showSuccessSnackBar(
      'تم تفريغ طابور العمليات ومزامنة ${unsynced.length} عناصر مع السيرفر بنجاح!',
      title: 'اكتمال المزامنة (Sync Complete)',
    );
  }

  @override
  Widget build(BuildContext context) {
    final pendingCount = _tasks.where((t) => !t.isSynced).length;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('مختبر Offline-First والتزامن'),
        backgroundColor: const Color(0xFF1E293B),
        actions: [
          const LabQuizAction(labId: 'offline-sync'),
          IconButton(
            icon: const Icon(Icons.auto_awesome, color: Color(0xFF38BDF8)),
            tooltip: 'اسأل الذكاء الاصطناعي عن Offline-First',
            onPressed: () => _openAiAssistant(pendingCount),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF38BDF8),
        foregroundColor: const Color(0xFF04111C),
        icon: const Icon(Icons.auto_awesome),
        label: const Text(
          'اسأل الـ AI عن المزامنة',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        onPressed: () => _openAiAssistant(pendingCount),
      ),
      body: ResponsiveContentWrapper(
        maxWidth: 1200,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // بطاقة الشرح
              _buildExplanationCard(),
              16.heightBox,

              // مفتاح محاكاة الاتصال بالإنترنت
              _buildNetworkToggleCard(pendingCount),
              16.heightBox,

              // إضافة مهمة جديدة
              _buildAddTaskInput(),
              16.heightBox,

              // قائمة المهام وحالة تزامنها
              _buildTaskList(),
              20.heightBox,

              // الكود الجاهز للنسخ
              _buildCodeSnippetCard(pendingCount),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExplanationCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFF38BDF8).withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.cloud_sync_rounded,
                color: Color(0xFF38BDF8),
                size: 22,
              ),
              8.widthBox,
              const Text(
                'مفهوم الـ Offline-First & Optimistic UI',
                style: TextStyle(
                  color: Color(0xFF38BDF8),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          8.heightBox,
          const Text(
            'تطبيقات الإنتاج الاحترافية لا تجعل المستخدم ينتظر استجابة السيرفر. عند إضافة أو تعديل عنصر:\n'
            '1. Optimistic Update: تحديث الواجهة فوراً.\n'
            '2. Local Cache: حفظ التغيير في قاعدة البيانات المحلية (Hive/Drift).\n'
            '3. Sync Engine: تشغيل طابور المزامنة في الخلفية بمجرد توفر الاتصال.',
            style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.45),
          ),
        ],
      ),
    );
  }

  Widget _buildNetworkToggleCard(int pendingCount) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _isOnline
              ? Colors.greenAccent.withValues(alpha: 0.4)
              : Colors.orangeAccent.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isOnline
                      ? '🟢 متصل بالإنترنت (Online)'
                      : '🔴 غير متصل (Offline Mode)',
                  style: TextStyle(
                    color: _isOnline ? Colors.greenAccent : Colors.orangeAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                4.heightBox,
                Text(
                  pendingCount > 0
                      ? '$pendingCount عمليات معلقة في طابور الانتظار ⏳'
                      : 'جميع البيانات متزامنة مع السيرفر بالكامل ✅',
                  style: const TextStyle(color: Colors.white60, fontSize: 11.5),
                ),
              ],
            ),
          ),
          Switch(
            value: _isOnline,
            activeThumbColor: Colors.greenAccent,
            onChanged: (val) {
              setState(() => _isOnline = val);
              if (val && pendingCount > 0) {
                _triggerSync();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAddTaskInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _taskController,
            style: const TextStyle(color: Colors.white, fontSize: 12.5),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFF1E293B),
              hintText: 'أضف مهمة لاختبار التزامن التفاؤلي...',
              hintStyle: const TextStyle(color: Colors.white38, fontSize: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        10.widthBox,
        ElevatedButton(
          onPressed: _addNewTask,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF38BDF8),
            foregroundColor: const Color(0xFF04111C),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            'إضافة',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildTaskList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '📋 قائمة المهام وطابور المزامنة:',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            if (_isSyncing)
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.cyanAccent,
                ),
              ),
          ],
        ),
        10.heightBox,
        ..._tasks.map(
          (task) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: task.isSynced
                    ? Colors.white10
                    : Colors.amber.withValues(alpha: 0.5),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  task.isSynced
                      ? Icons.check_circle_rounded
                      : Icons.pending_rounded,
                  color: task.isSynced
                      ? Colors.greenAccent
                      : Colors.amberAccent,
                  size: 20,
                ),
                10.widthBox,
                Expanded(
                  child: Text(
                    task.title,
                    style: const TextStyle(color: Colors.white, fontSize: 12.5),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: task.isSynced
                        ? Colors.green.withValues(alpha: 0.15)
                        : Colors.amber.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    task.isSynced ? 'متزامن (Synced)' : 'في الانتظار (Pending)',
                    style: TextStyle(
                      color: task.isSynced
                          ? Colors.greenAccent
                          : Colors.amberAccent,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCodeSnippetCard(int pendingCount) {
    final code = _buildDynamicOfflineCode(pendingCount);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '💻 معمارية المزامنة والتحديث التفاؤلي الحية:',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF38BDF8).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Dynamic Live Code',
                  style: TextStyle(
                    color: Color(0xFF38BDF8),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          10.heightBox,
          CopyableCodeBlock(
            code: code,
            copiedMessage: 'تم نسخ كود Offline Sync المحدث',
            copyTooltip: 'نسخ الكود',
          ),
        ],
      ),
    );
  }
}
