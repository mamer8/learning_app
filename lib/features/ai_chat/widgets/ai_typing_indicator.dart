import 'package:flutter/material.dart';

/// مؤشر تفكير وتحليل الذكاء الاصطناعي بنمط النبض الحديث
class AiTypingIndicator extends StatefulWidget {
  const AiTypingIndicator({
    this.statusText = 'المهندس الذكي يقوم بالتحليل وصياغة الحل الأمثل...',
    super.key,
  });

  final String statusText;

  @override
  State<AiTypingIndicator> createState() => _AiTypingIndicatorState();
}

class _AiTypingIndicatorState extends State<AiTypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(4),
          ),
          border: Border.all(color: const Color(0xFF14B8A6).withValues(alpha: 0.3)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x2214B8A6),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // أيقونة المساعد النابضة
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF14B8A6).withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.psychology_rounded,
                color: Color(0xFF5EEAD4),
                size: 16,
              ),
            ),
            const SizedBox(width: 10),
            // النقاط الثلاث المتحركة
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Row(
                  children: List.generate(3, (index) {
                    final delay = index * 0.2;
                    final progress = (_controller.value - delay) % 1.0;
                    final scale = 0.5 + (0.5 * (1 - (progress - 0.5).abs() * 2));
                    final opacity = 0.3 + (0.7 * (1 - (progress - 0.5).abs() * 2));

                    return Transform.scale(
                      scale: scale.clamp(0.5, 1.2),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2.5),
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: const Color(0xFF5EEAD4).withValues(alpha: opacity.clamp(0.2, 1.0)),
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                widget.statusText,
                style: const TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
