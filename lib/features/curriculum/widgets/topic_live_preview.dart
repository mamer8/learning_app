import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../curriculum_data.dart';

/// ⚡ ويدجت المعاينة الحية والتفاعلية لمواضيع المنهج التعليمي
class TopicLivePreview extends StatefulWidget {
  const TopicLivePreview({
    required this.level,
    required this.topic,
    required this.isArabic,
    super.key,
    this.onCodeChanged,
  });

  final CurriculumLevel level;
  final CurriculumTopic topic;
  final bool isArabic;
  final ValueChanged<String>? onCodeChanged;

  @override
  State<TopicLivePreview> createState() => _TopicLivePreviewState();
}

class _TopicLivePreviewState extends State<TopicLivePreview> {
  // --- Glassmorphism State (Level 2 Topic 2) ---
  double _blurSigma = 14.0;
  double _glassOpacity = 0.18;
  final double _glassRadius = 24.0;
  final Color _glassTint = Colors.teal;

  // --- Typography State (Level 2 Topic 5) ---
  String _customText = 'فلاتر 3.24 الحديثة 🚀';
  double _fontSize = 24.0;
  int _selectedGradientIndex = 0;
  final List<List<Color>> _gradients = [
    [const Color(0xFFFFD700), const Color(0xFFFF8C00), const Color(0xFFFF0080)], // Gold Sunset
    [const Color(0xFF00F2FE), const Color(0xFF4FACFE), const Color(0xFF6B11FF)], // Ocean Electric
    [const Color(0xFF00FF87), const Color(0xFF60EFFF), const Color(0xFF00B4D8)], // Cyber Emerald
    [const Color(0xFFFF416C), const Color(0xFFFF4B2B), const Color(0xFFF9D423)], // Fiery Lava
  ];

  // --- Layout State (Level 2 Topic 1) ---
  final List<String> _tags = ['Flutter', 'Dart 3', 'Clean Arch', 'Slivers', 'Wasm'];
  final TextEditingController _newTagCtrl = TextEditingController();
  bool _showBadge = true;

  // --- Forms State (Level 2 Topic 6) ---
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController(text: 'developer@flutter.dev');
  String _selectedRole = 'developer';
  double _experienceYears = 4.0;

  // --- Animations State (Level 2 Topic 8) ---
  bool _isExpanded = false;
  Curve _selectedCurve = Curves.easeOutBack;

  // --- Gestures State (Level 2 Topic 7) ---
  int _tapCount = 0;
  int _doubleTapCount = 0;
  int _longPressCount = 0;
  bool _isBadgeDropped = false;

  // --- Async Future State (Level 2 Topic 10) ---
  Future<String>? _apiSimulationFuture;

  // --- Lists State (Level 2 Topic 3) ---
  late List<String> _liveProducts;

  // --- Dart 3 Records State (Level 1 Topic 1) ---
  int _selectedStatusCode = 200;

  // --- Dart 3 Streams State (Level 1 Topic 4 / 17) ---
  int _streamTick = 0;
  bool _isStreamRunning = false;
  Timer? _streamTimer;

  // --- TypedData State (Level 1 Topic 19) ---
  double _rawSpeed = 85.5;
  final int _rawPacketId = 101;

  @override
  void initState() {
    super.initState();
    _liveProducts = [
      'هاتف ذكي فائق السرعة 📱',
      'سماعات لاسلكية عازلة للضوضاء 🎧',
      'شاحن سريع GaN بقدرة 65W ⚡',
      'لوحة مفاتيح ميكانيكية RGB ⌨️',
    ];
  }

  @override
  void dispose() {
    _newTagCtrl.dispose();
    _emailCtrl.dispose();
    _streamTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAr = widget.isArabic;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF101828),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: widget.level.color.withValues(alpha: 0.35), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: widget.level.color.withValues(alpha: 0.08),
            blurRadius: 18,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF172033),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
              border: Border(bottom: BorderSide(color: const Color(0xFF24324A))),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFF10B981),
                          shape: BoxShape.circle,
                        ),
                      ),
                      6.widthBox,
                      Text(
                        isAr ? 'معاينة حية تفاعلية' : 'LIVE INTERACTIVE PREVIEW',
                        style: const TextStyle(
                          color: Color(0xFF34D399),
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  isAr ? 'جرّب وعدّل في الوقت الفعلي' : 'Tweak & test in real-time',
                  style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
                ),
              ],
            ),
          ),

          // Main Live Preview Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: _buildTopicSpecificPreview(isAr),
          ),
        ],
      ),
    );
  }

  Widget _buildTopicSpecificPreview(bool isAr) {
    final title = widget.topic.title.ar.toLowerCase();
    final lvl = widget.level.number;

    // --- LEVEL 2: WIDGETS ENCYCLOPEDIA ---
    if (lvl == 2) {
      if (title.contains('تخطيط') || title.contains('layout')) {
        return _buildLayoutSandbox(isAr);
      } else if (title.contains('صناديق') || title.contains('glass') || title.contains('زجاج')) {
        return _buildGlassmorphismSandbox(isAr);
      } else if (title.contains('قوائم') || title.contains('list')) {
        return _buildListsSandbox(isAr);
      } else if (title.contains('slivers') || title.contains('سلايفر')) {
        return _buildSliversSandbox(isAr);
      } else if (title.contains('نصوص') || title.contains('text') || title.contains('shader')) {
        return _buildTypographySandbox(isAr);
      } else if (title.contains('نماذج') || title.contains('form') || title.contains('إدخال')) {
        return _buildFormSandbox(isAr);
      } else if (title.contains('أزرار') || title.contains('gesture') || title.contains('interactive')) {
        return _buildGesturesSandbox(isAr);
      } else if (title.contains('حركة') || title.contains('animation') || title.contains('animated')) {
        return _buildAnimationsSandbox(isAr);
      } else if (title.contains('حوارات') || title.contains('dialog') || title.contains('bottomsheet')) {
        return _buildDialogsSandbox(isAr);
      } else if (title.contains('بناء') || title.contains('async') || title.contains('futurebuilder')) {
        return _buildAsyncBuildersSandbox(isAr);
      }
    }

    // --- LEVEL 1: DART 3 FOUNDATIONS ---
    if (lvl == 1) {
      if (title.contains('record') || title.contains('pattern')) {
        return _buildRecordsPatternSandbox(isAr);
      } else if (title.contains('stream') || title.contains('تدفق')) {
        return _buildStreamSandbox(isAr);
      } else if (title.contains('typed') || title.contains('byte') || title.contains('ثنائية')) {
        return _buildTypedDataSandbox(isAr);
      }
    }

    // Default Fallback Interactive Terminal for other topics
    return _buildGenericInteractiveTerminal(isAr);
  }

  // ===========================================================================
  // 1. Layout Sandbox (Scaffold, Stack, Positioned, Wrap)
  // ===========================================================================
  Widget _buildLayoutSandbox(bool isAr) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Stack with Positioned live preview
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: const LinearGradient(colors: [Color(0xFF1E293B), Color(0xFF334155)]),
                border: Border.all(color: const Color(0xFF475569)),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.layers_rounded, color: Colors.cyanAccent, size: 28),
                    8.widthBox,
                    Text(
                      isAr ? 'عنصر الحاوية الأساسي (Stack Base)' : 'Stack Base Container',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            if (_showBadge)
              Positioned(
                top: 10,
                right: isAr ? null : 10,
                left: isAr ? 10 : null,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(color: Colors.red.withValues(alpha: 0.5), blurRadius: 8),
                    ],
                  ),
                  child: const Text(
                    'Positioned: جديد 🔥',
                    style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        ),
        14.heightBox,

        // Wrap live dynamic tags
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              isAr ? 'عناصر الـ Wrap التلقائية (تلتف تلقائياً):' : 'Wrap Dynamic Flow Tags:',
              style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12, fontWeight: FontWeight.bold),
            ),
            TextButton.icon(
              onPressed: () => setState(() => _showBadge = !_showBadge),
              icon: Icon(_showBadge ? Icons.visibility : Icons.visibility_off, size: 16),
              label: Text(
                _showBadge ? (isAr ? 'إخفاء الشارة' : 'Hide Badge') : (isAr ? 'إظهار الشارة' : 'Show Badge'),
                style: const TextStyle(fontSize: 11),
              ),
            ),
          ],
        ),
        8.heightBox,
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: _tags.map((tag) {
            return Chip(
              backgroundColor: const Color(0xFF1E293B),
              side: const BorderSide(color: Color(0xFF38BDF8)),
              label: Text(tag, style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 12)),
              deleteIcon: const Icon(Icons.close, size: 14, color: Colors.white70),
              onDeleted: () => setState(() => _tags.remove(tag)),
            );
          }).toList(),
        ),
        10.heightBox,
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 38,
                child: TextField(
                  controller: _newTagCtrl,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                  decoration: InputDecoration(
                    hintText: isAr ? 'أضف وسماً جديداً للـ Wrap...' : 'Add tag to Wrap...',
                    hintStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 11),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    filled: true,
                    fillColor: const Color(0xFF1E293B),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                  ),
                  onSubmitted: (v) {
                    if (v.trim().isNotEmpty) {
                      setState(() {
                        _tags.add(v.trim());
                        _newTagCtrl.clear();
                      });
                    }
                  },
                ),
              ),
            ),
            8.widthBox,
            ElevatedButton(
              onPressed: () {
                if (_newTagCtrl.text.trim().isNotEmpty) {
                  setState(() {
                    _tags.add(_newTagCtrl.text.trim());
                    _newTagCtrl.clear();
                  });
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF38BDF8)),
              child: Text(isAr ? 'إضافة' : 'Add', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12)),
            ),
          ],
        ),
      ],
    );
  }

  // ===========================================================================
  // 2. Glassmorphism Sandbox (Container, ClipRRect, BackdropFilter)
  // ===========================================================================
  Widget _buildGlassmorphismSandbox(bool isAr) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Live Glass Card over colorful background
        Container(
          height: 170,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [Color(0xFF0EA5E9), Color(0xFF8B5CF6), Color(0xFFEC4899)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(_glassRadius),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: _blurSigma, sigmaY: _blurSigma),
                child: Container(
                  width: 280,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: _glassOpacity),
                    borderRadius: BorderRadius.circular(_glassRadius),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.auto_awesome_rounded, color: _glassTint, size: 22),
                          8.widthBox,
                          Text(
                            isAr ? 'كارت زجاجي بلوري حقيقي' : 'Live Glassmorphism Card',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ],
                      ),
                      8.heightBox,
                      Text(
                        isAr
                            ? 'الضبابية: ${_blurSigma.toInt()}px | الشفافية: ${(_glassOpacity * 100).toInt()}%'
                            : 'Blur: ${_blurSigma.toInt()}px | Opacity: ${(_glassOpacity * 100).toInt()}%',
                        style: const TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        14.heightBox,

        // Live interactive sliders
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isAr ? 'درجة الضبابية (Blur Sigma): ${_blurSigma.toInt()}' : 'Blur Sigma: ${_blurSigma.toInt()}',
                    style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 11),
                  ),
                  Slider(
                    value: _blurSigma,
                    min: 0,
                    max: 30,
                    activeColor: const Color(0xFF38BDF8),
                    onChanged: (v) => setState(() => _blurSigma = v),
                  ),
                ],
              ),
            ),
            12.widthBox,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isAr ? 'الشفافية (Opacity): ${(_glassOpacity * 100).toInt()}%' : 'Opacity: ${(_glassOpacity * 100).toInt()}%',
                    style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 11),
                  ),
                  Slider(
                    value: _glassOpacity,
                    min: 0.05,
                    max: 0.5,
                    activeColor: const Color(0xFFEC4899),
                    onChanged: (v) => setState(() => _glassOpacity = v),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ===========================================================================
  // 3. Lists & Dismissible Sandbox
  // ===========================================================================
  Widget _buildListsSandbox(bool isAr) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              isAr ? 'اسحب أي عنصر لحذفه مع تأثير فوري:' : 'Swipe item to dismiss with live animation:',
              style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
            ),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _liveProducts.add(isAr ? 'منتج إضافي جديد #${_liveProducts.length + 1} 📦' : 'New Item #${_liveProducts.length + 1} 📦');
                });
              },
              icon: const Icon(Icons.add_circle, size: 14),
              label: Text(isAr ? 'إضافة عنصر' : 'Add Item', style: const TextStyle(fontSize: 11)),
            ),
          ],
        ),
        6.heightBox,
        Container(
          constraints: const BoxConstraints(maxHeight: 190),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFF334155)),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: _liveProducts.length,
            separatorBuilder: (_, index) => const Divider(height: 1, color: Color(0xFF1E293B)),
            itemBuilder: (context, i) {
              final product = _liveProducts[i];
              return Dismissible(
                key: ValueKey(product),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.redAccent,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16),
                  child: const Icon(Icons.delete_forever, color: Colors.white),
                ),
                onDismissed: (_) {
                  setState(() => _liveProducts.removeAt(i));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: const Duration(seconds: 2),
                      content: Text(isAr ? 'تم حذف: $product' : 'Deleted: $product'),
                      action: SnackBarAction(
                        label: isAr ? 'تراجع' : 'Undo',
                        onPressed: () => setState(() => _liveProducts.insert(i, product)),
                      ),
                    ),
                  );
                },
                child: ListTile(
                  dense: true,
                  leading: CircleAvatar(
                    radius: 12,
                    backgroundColor: const Color(0xFF38BDF8),
                    child: Text('${i + 1}', style: const TextStyle(fontSize: 10, color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                  title: Text(product, style: const TextStyle(color: Colors.white, fontSize: 12)),
                  trailing: const Icon(Icons.swipe_left_rounded, color: Color(0xFF64748B), size: 16),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // 4. Slivers Pipeline Sandbox
  // ===========================================================================
  Widget _buildSliversSandbox(bool isAr) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          isAr ? 'مسار تمرير CustomScrollView مصغر (مرر وشاهد تقلص الـ SliverAppBar):' : 'Interactive mini CustomScrollView (Scroll down to watch SliverAppBar collapse):',
          style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
        ),
        8.heightBox,
        Container(
          height: 200,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF38BDF8).withValues(alpha: 0.5)),
          ),
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 90,
                pinned: true,
                backgroundColor: const Color(0xFF0F766E),
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    isAr ? 'SliverAppBar المطاطي' : 'Collapsible SliverAppBar',
                    style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  centerTitle: true,
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: [Color(0xFF0F766E), Color(0xFF0369A1)]),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    isAr ? 'عناصر داخل SliverGrid:' : 'Items inside SliverGrid:',
                    style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SliverGrid.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2.2,
                  mainAxisSpacing: 6,
                  crossAxisSpacing: 6,
                ),
                itemCount: 8,
                itemBuilder: (context, i) => Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF334155)),
                  ),
                  child: Center(
                    child: Text(
                      isAr ? 'عنصر #${i + 1} 📦' : 'Item #${i + 1} 📦',
                      style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 11),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // 5. Typography & ShaderMask Sandbox
  // ===========================================================================
  Widget _buildTypographySandbox(bool isAr) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Live Gradient Text Preview with ShaderMask
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF0B132B),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF1E293B)),
          ),
          child: Center(
            child: ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (bounds) => LinearGradient(
                colors: _gradients[_selectedGradientIndex],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: Text(
                _customText.isEmpty ? 'Dart & Flutter' : _customText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: _fontSize,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ),
        12.heightBox,

        // Text input to change text live
        TextField(
          style: const TextStyle(color: Colors.white, fontSize: 13),
          decoration: InputDecoration(
            labelText: isAr ? 'اكتب نصاً لتطبيق التدرج عليه مباشرة:' : 'Type custom text for live gradient shader:',
            labelStyle: const TextStyle(color: Color(0xFF38BDF8), fontSize: 11),
            filled: true,
            fillColor: const Color(0xFF1E293B),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
          ),
          onChanged: (v) => setState(() => _customText = v),
        ),
        10.heightBox,

        // Gradient & Size controls
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isAr ? 'حجم الخط: ${_fontSize.toInt()}px' : 'Font Size: ${_fontSize.toInt()}px',
                    style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 11),
                  ),
                  Slider(
                    value: _fontSize,
                    min: 16,
                    max: 36,
                    activeColor: const Color(0xFF38BDF8),
                    onChanged: (v) => setState(() => _fontSize = v),
                  ),
                ],
              ),
            ),
            12.widthBox,
            // Gradient selector circles
            Row(
              children: List.generate(_gradients.length, (idx) {
                final isSel = idx == _selectedGradientIndex;
                return GestureDetector(
                  onTap: () => setState(() => _selectedGradientIndex = idx),
                  child: Container(
                    margin: const EdgeInsets.only(left: 6),
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(colors: _gradients[idx]),
                      border: Border.all(color: isSel ? Colors.white : Colors.transparent, width: 2),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ],
    );
  }

  // ===========================================================================
  // 6. Form & Inputs Sandbox
  // ===========================================================================
  Widget _buildFormSandbox(bool isAr) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _emailCtrl,
            style: const TextStyle(color: Colors.white, fontSize: 12),
            decoration: InputDecoration(
              labelText: isAr ? 'البريد الإلكتروني' : 'Email Address',
              prefixIcon: const Icon(Icons.email, size: 18, color: Color(0xFF38BDF8)),
              filled: true,
              fillColor: const Color(0xFF1E293B),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
            ),
            validator: (v) => (v == null || !v.contains('@')) ? (isAr ? 'أدخل بريداً إلكترونياً صحيحاً' : 'Invalid email') : null,
          ),
          10.heightBox,
          SegmentedButton<String>(
            segments: [
              ButtonSegment(value: 'developer', label: Text(isAr ? 'مطور' : 'Dev', style: const TextStyle(fontSize: 11))),
              ButtonSegment(value: 'designer', label: Text(isAr ? 'مصمم' : 'UI', style: const TextStyle(fontSize: 11))),
              ButtonSegment(value: 'manager', label: Text(isAr ? 'مدير' : 'PM', style: const TextStyle(fontSize: 11))),
            ],
            selected: {_selectedRole},
            onSelectionChanged: (s) => setState(() => _selectedRole = s.first),
          ),
          10.heightBox,
          Row(
            children: [
              Text(
                isAr ? 'الخبرة: ${_experienceYears.toInt()} سنوات' : 'Experience: ${_experienceYears.toInt()} yrs',
                style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 11),
              ),
              Expanded(
                child: Slider(
                  value: _experienceYears,
                  min: 0,
                  max: 10,
                  divisions: 10,
                  activeColor: const Color(0xFF38BDF8),
                  onChanged: (v) => setState(() => _experienceYears = v),
                ),
              ),
            ],
          ),
          ElevatedButton.icon(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: const Color(0xFF059669),
                    content: Text(isAr ? '✅ تم التحقق من البيانات وحفظ النموذج بنجاح!' : '✅ Form validated successfully!'),
                  ),
                );
              }
            },
            icon: const Icon(Icons.check_circle_rounded, size: 18),
            label: Text(isAr ? 'تحقق من صحة النموذج الآن' : 'Validate Form Now', style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // 7. Gestures & Drag/Drop Sandbox
  // ===========================================================================
  Widget _buildGesturesSandbox(bool isAr) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Multi-gesture touch pad
        GestureDetector(
          onTap: () => setState(() => _tapCount++),
          onDoubleTap: () => setState(() => _doubleTapCount++),
          onLongPress: () => setState(() => _longPressCount++),
          child: Container(
            height: 90,
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF38BDF8).withValues(alpha: 0.6), width: 1.5),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isAr ? 'منطقة رصد الإيماءات (انقر، انقر مرتين، أو اضغط مطولاً)' : 'Gesture Touch Pad (Tap, Double Tap, or Long Press)',
                    style: const TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  6.heightBox,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _badgeCount('Tap: $_tapCount', Colors.cyan),
                      8.widthBox,
                      _badgeCount('Double: $_doubleTapCount', Colors.amber),
                      8.widthBox,
                      _badgeCount('Long: $_longPressCount', Colors.pinkAccent),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        12.heightBox,

        // Draggable & DragTarget Box
        Row(
          children: [
            Expanded(
              child: Draggable<String>(
                data: 'PRO_VIP',
                feedback: Material(
                  color: Colors.transparent,
                  child: Chip(backgroundColor: Colors.amber, label: Text(isAr ? 'وسام PRO 🌟' : 'PRO Badge 🌟')),
                ),
                childWhenDragging: Opacity(
                  opacity: 0.3,
                  child: Chip(label: Text(isAr ? 'اسحبني للهدف ⬅️' : 'Drag to target ➡️')),
                ),
                child: Chip(
                  backgroundColor: const Color(0xFFF59E0B),
                  label: Text(isAr ? 'اسحبني للهدف 🌟' : 'Drag me 🌟', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            12.widthBox,
            Expanded(
              child: DragTarget<String>(
                onAcceptWithDetails: (details) {
                  setState(() => _isBadgeDropped = true);
                },
                builder: (context, candidateData, rejectedData) {
                  return Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: candidateData.isNotEmpty ? const Color(0xFF059669) : const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: candidateData.isNotEmpty ? Colors.white : const Color(0xFF334155), width: 1.5),
                    ),
                    child: Center(
                      child: Text(
                        _isBadgeDropped
                            ? (isAr ? '✅ تم الإسقاط بنجاح!' : '✅ Dropped!')
                            : (isAr ? 'مستقبل السحب (Drop Here)' : 'Drop Target Here'),
                        style: TextStyle(
                          color: _isBadgeDropped ? const Color(0xFF34D399) : Colors.white70,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _badgeCount(String label, Color col) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: col.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(6)),
      child: Text(label, style: TextStyle(color: col, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }

  // ===========================================================================
  // 8. Animations Sandbox (AnimatedContainer, Switcher)
  // ===========================================================================
  Widget _buildAnimationsSandbox(bool isAr) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: GestureDetector(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: _selectedCurve,
              width: _isExpanded ? 260 : 130,
              height: _isExpanded ? 90 : 50,
              decoration: BoxDecoration(
                color: _isExpanded ? const Color(0xFF0D9488) : const Color(0xFF4F46E5),
                borderRadius: BorderRadius.circular(_isExpanded ? 24 : 10),
                boxShadow: [
                  BoxShadow(
                    color: (_isExpanded ? Colors.teal : Colors.indigo).withValues(alpha: 0.4),
                    blurRadius: 16,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  _isExpanded ? (isAr ? 'انقر للتصغير 🔽' : 'Tap to Shrink 🔽') : (isAr ? 'انقر للتوسيع 🔼' : 'Tap to Expand 🔼'),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ),
          ),
        ),
        12.heightBox,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isAr ? 'نوع المنحنى (Curve):' : 'Animation Curve:',
              style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
            ),
            8.widthBox,
            DropdownButton<Curve>(
              value: _selectedCurve,
              dropdownColor: const Color(0xFF1E293B),
              style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 12),
              items: const [
                DropdownMenuItem(value: Curves.easeOutBack, child: Text('Curves.easeOutBack')),
                DropdownMenuItem(value: Curves.bounceOut, child: Text('Curves.bounceOut')),
                DropdownMenuItem(value: Curves.elasticOut, child: Text('Curves.elasticOut')),
                DropdownMenuItem(value: Curves.easeInOut, child: Text('Curves.easeInOut')),
              ],
              onChanged: (c) {
                if (c != null) setState(() => _selectedCurve = c);
              },
            ),
          ],
        ),
      ],
    );
  }

  // ===========================================================================
  // 9. Dialogs & BottomSheets Sandbox
  // ===========================================================================
  Widget _buildDialogsSandbox(bool isAr) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                builder: (_) => Container(
                  padding: const EdgeInsets.all(20),
                  color: const Color(0xFF101828),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade600, borderRadius: BorderRadius.circular(2))),
                      14.heightBox,
                      ListTile(
                        leading: const Icon(Icons.camera_alt, color: Color(0xFF38BDF8)),
                        title: Text(isAr ? 'التقاط صورة بالكاميرا' : 'Take Photo', style: const TextStyle(color: Colors.white)),
                        onTap: () => Navigator.pop(context),
                      ),
                      ListTile(
                        leading: const Icon(Icons.photo_library, color: Color(0xFFEC4899)),
                        title: Text(isAr ? 'اختيار من الاستوديو' : 'Choose from Gallery', style: const TextStyle(color: Colors.white)),
                        onTap: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
              );
            },
            icon: const Icon(Icons.vertical_align_top_rounded, size: 16),
            label: Text(isAr ? 'BottomSheet' : 'BottomSheet', style: const TextStyle(fontSize: 11)),
          ),
        ),
        8.widthBox,
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  backgroundColor: const Color(0xFF101828),
                  title: Text(isAr ? 'تأكيد الحذف؟' : 'Confirm Action?'),
                  content: Text(isAr ? 'هذا تطبيق حي للـ AlertDialog في فلاتر.' : 'This is a live AlertDialog demonstration in Flutter.'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context), child: Text(isAr ? 'إلغاء' : 'Cancel')),
                    ElevatedButton(onPressed: () => Navigator.pop(context), child: Text(isAr ? 'موافق' : 'OK')),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.warning_amber_rounded, size: 16),
            label: Text(isAr ? 'AlertDialog' : 'AlertDialog', style: const TextStyle(fontSize: 11)),
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // 10. Async & Reactive Builders Sandbox
  // ===========================================================================
  Widget _buildAsyncBuildersSandbox(bool isAr) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _apiSimulationFuture = Future.delayed(
                      const Duration(seconds: 2),
                      () => isAr ? 'بيانات المستخدم: أحمد محمود (تم التحميل بنجاح ✅)' : 'User Data: Ahmed (Loaded successfully ✅)',
                    );
                  });
                },
                icon: const Icon(Icons.download_rounded, size: 16),
                label: Text(isAr ? 'محاكاة API ناجح (2ث)' : 'Simulate API Success', style: const TextStyle(fontSize: 11)),
              ),
            ),
            8.widthBox,
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent.withValues(alpha: 0.2)),
                onPressed: () {
                  setState(() {
                    _apiSimulationFuture = Future.delayed(
                      const Duration(seconds: 2),
                      () => throw Exception(isAr ? 'تعذر الاتصال بالخادم (خطأ 500)' : 'Server 500 Network Error'),
                    );
                  });
                },
                icon: const Icon(Icons.error_outline, size: 16, color: Colors.redAccent),
                label: Text(isAr ? 'محاكاة خطأ' : 'Simulate Error', style: const TextStyle(color: Colors.redAccent, fontSize: 11)),
              ),
            ),
          ],
        ),
        10.heightBox,
        Container(
          height: 70,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF1E293B)),
          ),
          child: Center(
            child: _apiSimulationFuture == null
                ? Text(isAr ? 'اضغط على أحد الأزرار لتشغيل الـ FutureBuilder ⏳' : 'Press a button to trigger FutureBuilder ⏳', style: const TextStyle(color: Color(0xFF64748B), fontSize: 11))
                : FutureBuilder<String>(
                    future: _apiSimulationFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)),
                            SizedBox(width: 10),
                            Text('جاري الاتصال بالخادم...', style: TextStyle(color: Colors.amberAccent, fontSize: 12)),
                          ],
                        );
                      } else if (snapshot.hasError) {
                        return Text('⚠️ ${snapshot.error}', style: const TextStyle(color: Colors.redAccent, fontSize: 11));
                      } else if (snapshot.hasData) {
                        return Text(snapshot.data!, style: const TextStyle(color: Color(0xFF34D399), fontSize: 12, fontWeight: FontWeight.bold));
                      }
                      return const SizedBox.shrink();
                    },
                  ),
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // Level 1: Records & Pattern Matching Sandbox
  // ===========================================================================
  Widget _buildRecordsPatternSandbox(bool isAr) {
    // Live pattern matching switch
    final (statusIcon, statusColor, statusDesc) = switch (_selectedStatusCode) {
      200 => (Icons.check_circle, Colors.greenAccent, isAr ? '200 OK: استجابة ناجحة وتفكيك البيانات' : '200 OK: Success & Destructured'),
      401 => (Icons.lock, Colors.amberAccent, isAr ? '401 Unauthorized: جلسة منتهية' : '401 Unauthorized: Expired token'),
      404 => (Icons.search_off, Colors.orangeAccent, isAr ? '404 Not Found: الصفحة غير موجودة' : '404 Not Found: Resource missing'),
      _ => (Icons.error, Colors.redAccent, isAr ? '500 Server Error: خطأ غير متوقع' : '500 Server Error: Unexpected error'),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          isAr ? 'اختر رمز الحالة لمشاهدة مطابقة النمط (Pattern Matching) في سطر واحد:' : 'Select HTTP status to watch single-line Pattern Matching:',
          style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
        ),
        8.heightBox,
        Row(
          children: [200, 401, 404, 500].map((code) {
            final isSel = _selectedStatusCode == code;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: ChoiceChip(
                  label: Text('$code', style: TextStyle(color: isSel ? Colors.black : Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                  selected: isSel,
                  selectedColor: const Color(0xFF38BDF8),
                  backgroundColor: const Color(0xFF1E293B),
                  onSelected: (_) => setState(() => _selectedStatusCode = code),
                ),
              ),
            );
          }).toList(),
        ),
        10.heightBox,
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: statusColor.withValues(alpha: 0.4)),
          ),
          child: Row(
            children: [
              Icon(statusIcon, color: statusColor, size: 24),
              10.widthBox,
              Expanded(
                child: Text(statusDesc, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // Level 1: Streams & Event Loop Sandbox
  // ===========================================================================
  Widget _buildStreamSandbox(bool isAr) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              isAr ? 'عداد تدفق الأحداث الحية (Stream Ticker):' : 'Live Stream Event Ticker:',
              style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
            ),
            ElevatedButton.icon(
              onPressed: () {
                if (_isStreamRunning) {
                  _streamTimer?.cancel();
                  setState(() => _isStreamRunning = false);
                } else {
                  setState(() => _isStreamRunning = true);
                  _streamTimer = Timer.periodic(const Duration(milliseconds: 600), (t) {
                    setState(() => _streamTick++);
                  });
                }
              },
              icon: Icon(_isStreamRunning ? Icons.pause : Icons.play_arrow, size: 16),
              label: Text(_isStreamRunning ? (isAr ? 'إيقاف' : 'Pause') : (isAr ? 'بدء التدفق' : 'Start Stream'), style: const TextStyle(fontSize: 11)),
            ),
          ],
        ),
        8.heightBox,
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF38BDF8).withValues(alpha: 0.4)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.sensors, color: Color(0xFF38BDF8), size: 24),
              10.widthBox,
              Text(
                isAr ? 'الأحداث المستلمة عبر التدفق: #$_streamTick' : 'Stream Events Emitted: #$_streamTick',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // Level 1: TypedData & Binary Data Sandbox
  // ===========================================================================
  Widget _buildTypedDataSandbox(bool isAr) {
    final byteData = ByteData(6);
    byteData.setUint16(0, _rawPacketId, Endian.big);
    byteData.setFloat32(2, _rawSpeed, Endian.big);
    final hexBytes = byteData.buffer.asUint8List().map((b) => b.toRadixString(16).padLeft(2, '0').toUpperCase()).join(' ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          isAr ? 'تشفير فوري في الذاكرة بـ Uint8List و ByteData:' : 'In-Memory Binary Encoding with ByteData:',
          style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
        ),
        8.heightBox,
        Row(
          children: [
            Expanded(
              child: Slider(
                value: _rawSpeed,
                min: 0,
                max: 200,
                activeColor: const Color(0xFF38BDF8),
                onChanged: (v) => setState(() => _rawSpeed = v),
              ),
            ),
            Text('${_rawSpeed.toStringAsFixed(1)} km/h', style: const TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold, fontSize: 12)),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(8)),
          child: Text(
            'Raw Hex Bytes: [ $hexBytes ] (Big-Endian)',
            style: const TextStyle(fontFamily: 'monospace', color: Color(0xFF34D399), fontSize: 12),
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // Generic Interactive Terminal for other levels
  // ===========================================================================
  Widget _buildGenericInteractiveTerminal(bool isAr) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Row(
        children: [
          Icon(widget.level.icon, color: widget.level.color, size: 28),
          12.widthBox,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.topic.title.value(isAr),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                ),
                4.heightBox,
                Text(
                  isAr ? '✅ الكود أدناه جاهز للتشغيل والتطبيق المباشر في مشروعك.' : '✅ Ready-to-use production code snippet below.',
                  style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
