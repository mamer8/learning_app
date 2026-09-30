import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/core.dart';
import '../../core/localization/app_localizations.dart';
import '../ai_chat/widgets/contextual_ai_sheet.dart';

/// حدث في خط تتبع الـ Stream (Stream Event)
class StreamLogItem {
  final String text;
  final Color color;
  final DateTime time;

  StreamLogItem({required this.text, required this.color}) : time = DateTime.now();
}

/// شاشة مختبر Streams & Reactive Programming
class StreamsRxScreen extends StatefulWidget {
  const StreamsRxScreen({super.key});

  @override
  State<StreamsRxScreen> createState() => _StreamsRxScreenState();
}

class _StreamsRxScreenState extends State<StreamsRxScreen> {
  late final StreamController<int> _rawStreamController;
  final List<StreamLogItem> _rawLogs = [];
  final List<StreamLogItem> _transformedLogs = [];

  StreamSubscription? _rawSub;
  StreamSubscription? _transformedSub;

  int _eventCounter = 1;
  bool _filterEvenOnly = true;
  bool _distinctOnly = true;
  int? _lastSeenValue;

  @override
  void initState() {
    super.initState();
    _rawStreamController = StreamController<int>.broadcast();
    _initSubscriptions();
  }

  void _initSubscriptions() {
    _rawSub = _rawStreamController.stream.listen((val) {
      setState(() {
        _rawLogs.insert(
          0,
          StreamLogItem(
            text: 'Raw Event: $val',
            color: const Color(0xFF38BDF8),
          ),
        );
      });
    });

    // Stream Transformers Pipeline
    _transformedSub = _rawStreamController.stream
        .where((val) => _filterEvenOnly ? val % 2 == 0 : true)
        .where((val) {
          if (_distinctOnly) {
            if (val == _lastSeenValue) return false;
            _lastSeenValue = val;
          }
          return true;
        })
        .map((val) => val * 10)
        .listen((transformedVal) {
          setState(() {
            _transformedLogs.insert(
              0,
              StreamLogItem(
                text: 'Filtered & Scaled (x10): $transformedVal',
                color: const Color(0xFF10B981),
              ),
            );
          });
        });
  }

  void _emitNumber(int num) {
    _rawStreamController.add(num);
  }

  void _clearLogs() {
    setState(() {
      _rawLogs.clear();
      _transformedLogs.clear();
      _lastSeenValue = null;
    });
  }

  String _getStreamsCode() {
    return '// خط معالجة الـ Streams التفاعلي (محدث بالخيارات الحالية):\n'
        'rawStreamController.stream\n'
        '  ${_filterEvenOnly ? ".where((val) => val % 2 == 0) // فلترة الأرقام الزوجية فقط\n  " : "// فلترة الزوجي معطلة\n  "}'
        '${_distinctOnly ? ".distinct() // منع تكرار نفس الرقم مرتين متتاليتين\n  " : "// منع التكرار معطل\n  "}'
        '.map((val) => val * 10) // ضرب القيمة في 10\n'
        '  .listen((transformedVal) {\n'
        '    print("Output: \$transformedVal");\n'
        '  });';
  }

  void _openAiCopilot(BuildContext context, bool isArabic) {
    ContextualAiSheet.show(
      context,
      topicTitle: isArabic ? 'مختبر الـ Streams والبرمجة التفاعلية (Reactive Streams)' : 'Streams & Reactive Programming Lab',
      topicCode: _getStreamsCode(),
      levelTitle: isArabic ? 'البرمجة التفاعلية وهندسة تدفق البيانات' : 'Reactive Programming & Data Pipelines',
      isArabic: isArabic,
    );
  }

  @override
  void dispose() {
    _rawSub?.cancel();
    _transformedSub?.cancel();
    _rawStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocaleScope.of(context);
    final isArabic = locale.isArabic;

    return Directionality(
      textDirection: locale.textDirection,
      child: Scaffold(
        appBar: AppBar(
          title: Text(isArabic ? 'مختبر Streams والبرمجة التفاعلية' : 'Streams & Reactive Lab'),
          actions: [
            IconButton(
              tooltip: isArabic ? 'اسأل المساعد الذكي' : 'Ask AI Copilot',
              icon: const Icon(Icons.psychology_rounded, color: Color(0xFF14B8A6)),
              onPressed: () => _openAiCopilot(context, isArabic),
            ),
            IconButton(
              icon: const Icon(Icons.delete_sweep_rounded),
              tooltip: isArabic ? 'مسح السجلات' : 'Clear',
              onPressed: _clearLogs,
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _openAiCopilot(context, isArabic),
          icon: const Icon(Icons.psychology_rounded, color: Color(0xFF04111C)),
          label: Text(
            isArabic ? 'اسأل المساعد الذكي عن هذا الكود' : 'Ask AI About This Code',
            style: const TextStyle(color: Color(0xFF04111C), fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color(0xFF14B8A6),
        ),
        body: ResponsiveContentWrapper(
          maxWidth: 1200,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
            children: [
              _buildIntroCard(isArabic),
              16.heightBox,

              // لوحة إرسال الأحداث
              _buildEmitterControls(isArabic),
              16.heightBox,

              // خط أنابيب المعالجة (Pipeline Operators)
              _buildPipelineSettings(isArabic),
              16.heightBox,

              // مساحة العرض البصري الحية
              _buildStreamsVisualizer(isArabic),
              16.heightBox,

              // كود الـ Stream الحي
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
        border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.water_drop_rounded, color: Color(0xFF34D399), size: 24),
          ),
          12.widthBox,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isArabic ? 'قوة Streams و Reactive Programming' : 'Reactive Streams Architecture',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                ),
                4.heightBox,
                Text(
                  isArabic
                      ? 'الـ Streams هي أساس نقل البيانات غير المتزامن (Async Data Flow) في Bloc و WebSocket. تتيح لك المعاملات (Operators) فلترة البيانات وتحويلها بسلاسة فائقة.'
                      : 'Streams power async event propagation. Master pipelines with where, distinct, map, and broadcast controllers.',
                  style: const TextStyle(fontSize: 12, color: Colors.white70, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmitterControls(bool isArabic) {
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
            isArabic ? 'لوحة إرسال الأحداث في التدفق (Emit Stream Events):' : 'Stream Event Emitter:',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
          ),
          12.heightBox,
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0284C7)),
                onPressed: () {
                  _emitNumber(_eventCounter++);
                },
                icon: const Icon(Icons.add_circle_outline_rounded, color: Colors.white, size: 16),
                label: Text(
                  isArabic ? 'إرسال رقم تسلسلي ($_eventCounter)' : 'Emit Next ($_eventCounter)',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  _emitNumber(4);
                },
                icon: const Icon(Icons.repeat_rounded, size: 16),
                label: Text(isArabic ? 'إرسال رقم مكرر (4)' : 'Emit Duplicate (4)', style: const TextStyle(fontSize: 12)),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF7C3AED)),
                onPressed: () {
                  for (int i = 1; i <= 5; i++) {
                    Future.delayed(Duration(milliseconds: i * 200), () => _emitNumber(i));
                  }
                },
                icon: const Icon(Icons.speed_rounded, color: Colors.white, size: 16),
                label: Text(isArabic ? 'إرسال دفعة سريعة (Burst)' : 'Emit Burst', style: const TextStyle(color: Colors.white, fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPipelineSettings(bool isArabic) {
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
            isArabic ? 'معاملات خط الأنابيب (Pipeline Operators):' : 'Pipeline Transformers:',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
          ),
          8.heightBox,
          SwitchListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: Text(
              isArabic ? 'تصفية الأرقام الزوجية فقط (.where(v % 2 == 0))' : 'Filter Even Only',
              style: const TextStyle(fontSize: 12, color: Colors.white),
            ),
            value: _filterEvenOnly,
            onChanged: (val) {
              setState(() => _filterEvenOnly = val);
              _rawSub?.cancel();
              _transformedSub?.cancel();
              _initSubscriptions();
            },
          ),
          SwitchListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: Text(
              isArabic ? 'منع التكرار المتتالي (.distinct())' : 'Distinct Until Changed',
              style: const TextStyle(fontSize: 12, color: Colors.white),
            ),
            value: _distinctOnly,
            onChanged: (val) {
              setState(() => _distinctOnly = val);
              _rawSub?.cancel();
              _transformedSub?.cancel();
              _initSubscriptions();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStreamsVisualizer(bool isArabic) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Raw Stream Column
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            height: 260,
            decoration: BoxDecoration(
              color: const Color(0xFF080D1A),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF0284C7).withValues(alpha: 0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Raw Source Stream',
                  style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF38BDF8)),
                ),
                8.heightBox,
                Expanded(
                  child: _rawLogs.isEmpty
                      ? Center(child: Text(isArabic ? 'بانتظار الأحداث...' : 'Idle...', style: const TextStyle(color: Colors.white38, fontSize: 11)))
                      : ListView.builder(
                          itemCount: _rawLogs.length,
                          itemBuilder: (context, i) {
                            final log = _rawLogs[i];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: log.color.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(log.text, style: TextStyle(color: log.color, fontSize: 10.5, fontWeight: FontWeight.bold)),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
        10.widthBox,

        // Transformed Stream Column
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            height: 260,
            decoration: BoxDecoration(
              color: const Color(0xFF080D1A),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Transformed Stream Output',
                  style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF34D399)),
                ),
                8.heightBox,
                Expanded(
                  child: _transformedLogs.isEmpty
                      ? Center(child: Text(isArabic ? 'لا توجد مخرجات بعد' : 'No Output', style: const TextStyle(color: Colors.white38, fontSize: 11)))
                      : ListView.builder(
                          itemCount: _transformedLogs.length,
                          itemBuilder: (context, i) {
                            final log = _transformedLogs[i];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: log.color.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(log.text, style: TextStyle(color: log.color, fontSize: 10.5, fontWeight: FontWeight.bold)),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ],
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
          Text(
            isArabic ? '💻 كود خط المعالجة التفاعلي (يتغير مباشرة مع الخيارات):' : '💻 Reactive Pipeline Code:',
            style: const TextStyle(color: Color(0xFF34D399), fontWeight: FontWeight.bold, fontSize: 13),
          ),
          10.heightBox,
          CopyableCodeBlock(
            code: _getStreamsCode(),
            copiedMessage: isArabic ? 'تم نسخ كود الـ Streams' : 'Streams code copied',
          ),
        ],
      ),
    );
  }
}
