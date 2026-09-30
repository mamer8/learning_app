import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/core.dart';
import '../ai_chat/widgets/contextual_ai_sheet.dart';

/// ⚡ مختبر الـ CustomPainter ومحاكي الجسيمات الفيزيائية
/// يوضح قوة الـ Canvas والـ Direct GPU Drawing في معالجة آلاف العناصر بحسابات رياضية سلسة بمعدل 60/120 FPS
class PhysicsPainterScreen extends StatefulWidget {
  const PhysicsPainterScreen({super.key});

  @override
  State<PhysicsPainterScreen> createState() => _PhysicsPainterScreenState();
}

class _PhysicsPainterScreenState extends State<PhysicsPainterScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ticker;
  final List<_Particle> _particles = [];
  final Random _random = Random();

  int _particleCount = 150;
  bool _enableGravity = true;
  bool _enableConnections = true;
  Offset? _touchPosition;

  @override
  void initState() {
    super.initState();
    _initParticles();
    _ticker = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    _ticker.addListener(_updatePhysics);
  }

  @override
  void dispose() {
    _ticker.removeListener(_updatePhysics);
    _ticker.dispose();
    super.dispose();
  }

  void _initParticles() {
    _particles.clear();
    for (int i = 0; i < _particleCount; i++) {
      _particles.add(
        _Particle(
          x: _random.nextDouble() * 350,
          y: _random.nextDouble() * 300,
          vx: (_random.nextDouble() - 0.5) * 4,
          vy: (_random.nextDouble() - 0.5) * 4,
          radius: _random.nextDouble() * 3 + 2,
          color: [
            const Color(0xFF14B8A6),
            const Color(0xFF60A5FA),
            const Color(0xFFF59E0B),
            const Color(0xFFEC4899),
          ][_random.nextInt(4)],
        ),
      );
    }
  }

  void _updatePhysics() {
    const double width = 350;
    const double height = 300;

    for (final p in _particles) {
      // تفاعل مع اللمس
      if (_touchPosition != null) {
        final dx = _touchPosition!.dx - p.x;
        final dy = _touchPosition!.dy - p.y;
        final dist = sqrt(dx * dx + dy * dy);
        if (dist < 100 && dist > 1) {
          // قوة تنافر عند الاقتراب من إصبع المستخدم
          p.vx -= (dx / dist) * 0.8;
          p.vy -= (dy / dist) * 0.8;
        }
      }

      // تطبيق الجاذبية إن كانت مفعلة
      if (_enableGravity) {
        p.vy += 0.08;
      }

      p.x += p.vx;
      p.y += p.vy;

      // ارتداد عند الاصطدام بالحواف
      if (p.x < p.radius) {
        p.x = p.radius;
        p.vx = -p.vx * 0.85;
      } else if (p.x > width - p.radius) {
        p.x = width - p.radius;
        p.vx = -p.vx * 0.85;
      }

      if (p.y < p.radius) {
        p.y = p.radius;
        p.vy = -p.vy * 0.85;
      } else if (p.y > height - p.radius) {
        p.y = height - p.radius;
        p.vy = -p.vy * 0.75; // احتكاك طفيف بالأرض
        p.vx *= 0.98;
      }
    }
    if (mounted) setState(() {});
  }

  String _getPhysicsCode() {
    return '// كود الـ CustomPainter المباشر على كرت الشاشة GPU (محدث بالقيم الحالية):\n'
        '// عدد الجسيمات الحالية: $_particleCount | الجاذبية: ${_enableGravity ? "مفعلة (vy += 0.08)" : "معطلة"} | شبكة الروابط: ${_enableConnections ? "مفعلة" : "معطلة"}\n\n'
        'class ParticleCanvasPainter extends CustomPainter {\n'
        '  final List<Particle> particles; // $_particleCount جسيم في تمريرة رسم واحدة\n'
        '  final bool enableConnections = $_enableConnections;\n'
        '  final bool enableGravity = $_enableGravity;\n\n'
        '  @override\n'
        '  void paint(Canvas canvas, Size size) {\n'
        '    final circlePaint = Paint()..style = PaintingStyle.fill;\n'
        '    final linePaint = Paint()..strokeWidth = 0.6;\n\n'
        '    // 1. رسم خطوط الروابط الذكية بين الجسيمات القريبة\n'
        '    if (enableConnections) {\n'
        '      for (int i = 0; i < particles.length; i++) {\n'
        '        for (int j = i + 1; j < particles.length; j++) {\n'
        '          final dist = calculateDistance(particles[i], particles[j]);\n'
        '          if (dist < 45) {\n'
        '            linePaint.color = Colors.cyan.withOpacity(1.0 - (dist / 45));\n'
        '            canvas.drawLine(particles[i].pos, particles[j].pos, linePaint);\n'
        '          }\n'
        '        }\n'
        '      }\n'
        '    }\n\n'
        '    // 2. رسم جميع الجسيمات بـ Single Draw Pass فائقة الكفاءة\n'
        '    for (final p in particles) {\n'
        '      circlePaint.color = p.color;\n'
        '      canvas.drawCircle(Offset(p.x, p.y), p.radius, circlePaint);\n'
        '    }\n'
        '  }\n\n'
        '  @override\n'
        '  bool shouldRepaint(covariant CustomPainter old) => true;\n'
        '}';
  }

  void _openAiCopilot(BuildContext context) {
    ContextualAiSheet.show(
      context,
      topicTitle: 'مختبر CustomPainter والمحاكي الفيزيائي للجسيمات',
      topicCode: _getPhysicsCode(),
      levelTitle: 'الرسم المباشر على GPU والأداء الرسومي',
      isArabic: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('مختبر CustomPainter & الفيزياء'),
        backgroundColor: const Color(0xFF1E293B),
        actions: [
          IconButton(
            tooltip: 'اسأل المساعد الذكي',
            icon: const Icon(Icons.psychology_rounded, color: Color(0xFF14B8A6)),
            onPressed: () => _openAiCopilot(context),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // بطاقة الشرح
            _buildExplanationCard(),
            16.heightBox,

            // مساحة الكانفاس التفاعلية (Canvas Sandbox)
            Center(
              child: GestureDetector(
                onPanUpdate: (details) => setState(() => _touchPosition = details.localPosition),
                onPanEnd: (_) => setState(() => _touchPosition = null),
                child: Container(
                  width: 350,
                  height: 300,
                  decoration: BoxDecoration(
                    color: const Color(0xFF020617),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF14B8A6).withValues(alpha: 0.4)),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF14B8A6).withValues(alpha: 0.15),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: CustomPaint(
                      painter: _ParticleCanvasPainter(
                        particles: _particles,
                        enableConnections: _enableConnections,
                        touchPosition: _touchPosition,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            12.heightBox,
            const Center(
              child: Text(
                '👆 المس واسحب إصبعك داخل المربع للتفاعل مع الجسيمات وإبعادها!',
                style: TextStyle(color: Colors.white70, fontSize: 11.5),
              ),
            ),
            16.heightBox,

            // لوحة التحكم التفاعلية
            _buildControlPanel(),
            16.heightBox,

            // الكود الجاهز للنسخ
            _buildCodeCard(),
          ],
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
        border: Border.all(color: const Color(0xFF14B8A6).withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome_motion_rounded, color: Color(0xFF14B8A6), size: 22),
              8.widthBox,
              const Text(
                'لماذا CustomPainter أسرع بـ 100x من شجرة الويدجتس؟',
                style: TextStyle(color: Color(0xFF14B8A6), fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ],
          ),
          8.heightBox,
          const Text(
            'لو رسمنا 500 كرة باستخدام 500 ويدجت `Container`، سينشئ Flutter 500 عنصر في شجرة الـ Widget والـ Element والـ RenderObject، مما يسبب بطئاً وتجميداً. باستخدام `CustomPainter`، نقوم بإصدار أوامر رسم مباشرة لـ GPU Canvas في تمريرة واحدة (Single Draw Call) بأعلى كفاءة ممكنة.',
            style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.45),
          ),
        ],
      ),
    );
  }

  Widget _buildControlPanel() {
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
          const Text(
            '⚙️ لوحة التحكم في المحرك الفيزيائي:',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
          ),
          12.heightBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('عدد الجسيمات ($_particleCount)', style: const TextStyle(color: Colors.white70, fontSize: 12)),
              Expanded(
                child: Slider(
                  value: _particleCount.toDouble(),
                  min: 50,
                  max: 400,
                  divisions: 7,
                  activeColor: const Color(0xFF14B8A6),
                  onChanged: (val) {
                    setState(() {
                      _particleCount = val.toInt();
                      _initParticles();
                    });
                  },
                ),
              ),
            ],
          ),
          SwitchListTile(
            title: const Text('تفعيل الجاذبية الأرضية', style: TextStyle(color: Colors.white, fontSize: 12.5)),
            value: _enableGravity,
            activeTrackColor: const Color(0xFF14B8A6),
            contentPadding: EdgeInsets.zero,
            onChanged: (val) => setState(() => _enableGravity = val),
          ),
          SwitchListTile(
            title: const Text('رسم شبكة الروابط الذكية (Particle Mesh)', style: TextStyle(color: Colors.white, fontSize: 12.5)),
            value: _enableConnections,
            activeTrackColor: const Color(0xFF14B8A6),
            contentPadding: EdgeInsets.zero,
            onChanged: (val) => setState(() => _enableConnections = val),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeCard() {
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
          const Text(
            '💻 كود الرسم المباشر على الكانفاس (Direct Canvas Drawing - يتغير مع الإعدادات):',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
          ),
          10.heightBox,
          CopyableCodeBlock(
            code: _getPhysicsCode(),
            copiedMessage: 'تم نسخ كود CustomPainter',
            copyTooltip: 'نسخ الكود',
          ),
        ],
      ),
    );
  }
}

class _Particle {
  double x, y;
  double vx, vy;
  double radius;
  Color color;

  _Particle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.radius,
    required this.color,
  });
}

class _ParticleCanvasPainter extends CustomPainter {
  final List<_Particle> particles;
  final bool enableConnections;
  final Offset? touchPosition;

  _ParticleCanvasPainter({
    required this.particles,
    required this.enableConnections,
    required this.touchPosition,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()..strokeWidth = 0.6;
    final circlePaint = Paint()..style = PaintingStyle.fill;

    // رسم خطوط الترابط بين الجسيمات القريبة
    if (enableConnections) {
      for (int i = 0; i < particles.length; i++) {
        for (int j = i + 1; j < particles.length; j++) {
          final dx = particles[i].x - particles[j].x;
          final dy = particles[i].y - particles[j].y;
          final dist = sqrt(dx * dx + dy * dy);

          if (dist < 45) {
            linePaint.color = Colors.cyan.withValues(alpha: (1.0 - (dist / 45)) * 0.4);
            canvas.drawLine(
              Offset(particles[i].x, particles[i].y),
              Offset(particles[j].x, particles[j].y),
              linePaint,
            );
          }
        }
      }
    }

    // رسم الجسيمات
    for (final p in particles) {
      circlePaint.color = p.color;
      canvas.drawCircle(Offset(p.x, p.y), p.radius, circlePaint);
    }

    // دائرة تأثير اللمس
    if (touchPosition != null) {
      final touchPaint = Paint()
        ..color = const Color(0xFF14B8A6).withValues(alpha: 0.25)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      canvas.drawCircle(touchPosition!, 70, touchPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticleCanvasPainter oldDelegate) => true;
}
