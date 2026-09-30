import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/core.dart';
import '../ai_chat/widgets/contextual_ai_sheet.dart';

/// 🔑 نموذج عنصر البيانات في القائمة
class LabItem {
  final String id;
  final String title;

  LabItem({required this.id, required this.title});
}

/// 🔑 مختبر الـ 3 Trees والـ Keys في Flutter
/// يوضح الخطأ الشهير في Flutter عند حذف أو إعادة ترتيب العناصر ذات الحالة (StatefulWidgets) بدون Key
class KeysScreen extends StatefulWidget {
  const KeysScreen({super.key});

  @override
  State<KeysScreen> createState() => _KeysScreenState();
}

class _KeysScreenState extends State<KeysScreen> {
  bool _useKeys = false;
  late List<LabItem> _items;

  @override
  void initState() {
    super.initState();
    _resetItems();
  }

  void _resetItems() {
    setState(() {
      _items = [
        LabItem(id: '1', title: 'مهمة 1: مراجعة الكور (Core Layer)'),
        LabItem(id: '2', title: 'مهمة 2: اختبار الـ Isolates'),
        LabItem(id: '3', title: 'مهمة 3: ضبط الـ Debouncer'),
        LabItem(id: '4', title: 'مهمة 4: تحسين الـ RepaintBoundary'),
      ];
    });
  }

  void _removeItem(int index) {
    if (_items.isEmpty) return;
    setState(() {
      final removed = _items.removeAt(index);
      if (!_useKeys) {
        context.showErrorSnackBar(
          'تم حذف "${removed.title}". لاحظ كيف احتفظ العنصر الجديد بالنص والحالة الخاطئة!',
          title: 'الخطأ بدون Key!',
        );
      } else {
        context.showSuccessSnackBar(
          'تم حذف "${removed.title}" بنجاح مع نقل الحالة الصحيحة بفضل ValueKey!',
          title: 'سليم مع Key',
        );
      }
    });
  }

  void _swapFirstTwo() {
    if (_items.length < 2) return;
    setState(() {
      final temp = _items[0];
      _items[0] = _items[1];
      _items[1] = temp;
    });
  }

  String _getKeysCode() {
    return '// كود بناء القائمة (الحالة الحالية: ${_useKeys ? "✅ استخدام ValueKey" : "❌ بدون Key"})\n'
        'ListView.builder(\n'
        '  itemCount: items.length,\n'
        '  itemBuilder: (context, index) {\n'
        '    final item = items[index];\n'
        '    return StatefulColorTile(\n'
        '      ${_useKeys ? "key: ValueKey(item.id), // يحافظ على ترابط الـ State مع العنصر الصحيح" : "// بدون key: سيفترض Flutter أن نوع الويدجت لم يتغير ويحتفظ بـ State العنصر السابق!"}\n'
        '      item: item,\n'
        '      index: index,\n'
        '      onDelete: () => removeItem(index),\n'
        '    );\n'
        '  },\n'
        ');\n\n'
        '// قاعدة المطابقة في Flutter Core (Widget.canUpdate):\n'
        'static bool canUpdate(Widget oldWidget, Widget newWidget) {\n'
        '  return oldWidget.runtimeType == newWidget.runtimeType && oldWidget.key == newWidget.key;\n'
        '}';
  }

  void _openAiCopilot(BuildContext context) {
    ContextualAiSheet.show(
      context,
      topicTitle: 'مختبر الـ 3 Trees والـ Keys في Flutter',
      topicCode: _getKeysCode(),
      levelTitle: 'بنية الشجرة وإدارة الحالة الموضعية (Keys & Elements)',
      isArabic: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('مختبر الـ 3 Trees والـ Keys'),
        backgroundColor: const Color(0xFF1E293B),
        actions: [
          IconButton(
            tooltip: 'اسأل المساعد الذكي',
            icon: const Icon(Icons.psychology_rounded, color: Color(0xFF14B8A6)),
            onPressed: () => _openAiCopilot(context),
          ),
          IconButton(
            tooltip: 'إعادة تعيين القائمة',
            onPressed: _resetItems,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAiCopilot(context),
        icon: const Icon(Icons.psychology_rounded, color: Color(0xFF04111C)),
        label: const Text(
          'اسأل المساعد الذكي عن هذا الكود',
          style: TextStyle(color: Color(0xFF04111C), fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF14B8A6),
      ),
      body: ResponsiveContentWrapper(
        maxWidth: 1200,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. بطاقة الشرح النظري
            _buildExplanationCard(),
            16.heightBox,

            // 2. مفتاح التبديل بين (مع Key / بدون Key)
            _buildKeyToggleCard(),
            16.heightBox,

            // 3. أزرار التحكم بالقائمة
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _items.length >= 2 ? _swapFirstTwo : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: 12.circularRadius,
                      ),
                    ),
                    icon: const Icon(Icons.swap_vert_rounded),
                    label: const Text('تبديل أول عنصرين'),
                  ),
                ),
                12.widthBox,
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _resetItems,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF475569),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: 12.circularRadius,
                      ),
                    ),
                    icon: const Icon(Icons.restart_alt_rounded),
                    label: const Text('إعادة تعيين'),
                  ),
                ),
              ],
            ),
            16.heightBox,

            // 4. عناصر القائمة التفاعلية
            const Text(
              '📝 قائمة المهام التفاعلية (اكتب ملاحظات بداخل كل حقل ثم احذف العنصر الأول لترى النتيجة):',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            12.heightBox,
            ...List.generate(_items.length, (index) {
              final item = _items[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _useKeys
                    ? StatefulColorTile(
                        key: ValueKey(item.id),
                        item: item,
                        index: index,
                        onDelete: () => _removeItem(index),
                      )
                    : StatefulColorTile(
                        item: item,
                        index: index,
                        onDelete: () => _removeItem(index),
                      ),
              );
            }),

            20.heightBox,
            // 5. مخطط الأشجار الثلاث (3 Trees Architecture Diagram)
            _buildThreeTreesArchitectureCard(),
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
        borderRadius: 16.circularRadius,
        border: Border.all(color: Colors.indigoAccent.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.account_tree_rounded,
                color: Colors.indigoAccent,
                size: 24,
              ),
              8.widthBox,
              const Text(
                'سر الأشجار الثلاث (Widget - Element - RenderObject)',
                style: TextStyle(
                  color: Colors.indigoAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          8.heightBox,
          const Text(
            '🔹 Widget Tree: مخططات بناء غير قابلة للتعديل (Immutable Blueprints) يُعاد إنشاؤها في كل فريم.\n'
            '🔹 Element Tree: العمود الفقري الحقيقي للتطبيق، هو من يحتفظ بالـ State ويدير دورة الحياة.\n'
            '🔹 RenderObject Tree: المسؤول عن الحسابات الهندسية والرسم على الشاشة.\n\n'
            '⚠️ بدون Key: عند حذف العنصر الأول، يطابق Flutter العناصر بحسب نوعها (runtimeType) فقط، فيبقى الـ State القديم مربوطاً بالعنصر الخاطئ!\n'
            '✅ مع ValueKey: يعرف الـ Element Tree هوية كل عنصر بدقة وينقل أو يحذف الـ State المقابل له.',
            style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyToggleCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: 16.circularRadius,
        border: Border.all(
          color: _useKeys ? Colors.greenAccent : Colors.orangeAccent,
          width: 1.5,
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
                  _useKeys
                      ? '✅ الوضع الآمن: استخدام ValueKey(item.id)'
                      : '⚠️ وضع التجربة: بدون Keys (Null Keys)',
                  style: TextStyle(
                    color: _useKeys ? Colors.greenAccent : Colors.orangeAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                4.heightBox,
                Text(
                  _useKeys
                      ? 'الـ Element Tree يطابق العناصر بناءً على النوع والـ Key معاً.'
                      : 'الـ Element Tree يعتمد على الترتيب والنوع فقط، مما يسبب خلط الـ States!',
                  style: const TextStyle(color: Colors.white54, fontSize: 11),
                ),
              ],
            ),
          ),
          Switch(
            value: _useKeys,
            activeThumbColor: Colors.greenAccent,
            onChanged: (val) {
              setState(() {
                _useKeys = val;
                _resetItems();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildThreeTreesArchitectureCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: 16.circularRadius,
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🔍 كود القائمة ومعادلة المطابقة (يتغير ديناميكياً مع المفتاح):',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          10.heightBox,
          CopyableCodeBlock(
            code: _getKeysCode(),
            copiedMessage: 'تم نسخ الكود',
            copyTooltip: 'نسخ الكود',
          ),
          12.heightBox,
          const Text(
            'عندما يكون key == null لكلا الويدجتين ونوعهما متطابق، يفترض Flutter أنهما نفس الويدجت، ولا يقوم بإعادة إنشاء الـ State أو حذفه بالشكل الصحيح!',
            style: TextStyle(color: Colors.white60, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

/// ويدجت ذو حالة داخلية (Stateful) يولد لوناً عشوائياً عند إنشائه ويحتفظ بنص بداخل الـ TextField
class StatefulColorTile extends StatefulWidget {
  final LabItem item;
  final int index;
  final VoidCallback onDelete;

  const StatefulColorTile({
    super.key,
    required this.item,
    required this.index,
    required this.onDelete,
  });

  @override
  State<StatefulColorTile> createState() => _StatefulColorTileState();
}

class _StatefulColorTileState extends State<StatefulColorTile> {
  late Color _tileColor;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    // توليد لون عشوائي مميز لكل State عند إنشائه لأول مرة
    final random = Random();
    _tileColor = Color.fromARGB(
      255,
      random.nextInt(150) + 40,
      random.nextInt(150) + 40,
      random.nextInt(150) + 40,
    );
    _notesController = TextEditingController(
      text: 'ملاحظة خاصة بالبند ${widget.item.id}',
    );
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _tileColor,
        borderRadius: 14.circularRadius,
        border: Border.all(color: Colors.white24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: 6.circularRadius,
                ),
                child: Text(
                  'ID: ${widget.item.id}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              10.widthBox,
              Expanded(
                child: Text(
                  widget.item.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.white,
                ),
                onPressed: widget.onDelete,
                tooltip: 'حذف هذا العنصر',
              ),
            ],
          ),
          8.heightBox,
          TextField(
            controller: _notesController,
            style: const TextStyle(color: Colors.white, fontSize: 12),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.black38,
              isDense: true,
              hintText: 'اكتب نصاً لترى بقاءه أو انتقاله عند الحذف...',
              hintStyle: const TextStyle(color: Colors.white38, fontSize: 11),
              border: OutlineInputBorder(
                borderRadius: 8.circularRadius,
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
