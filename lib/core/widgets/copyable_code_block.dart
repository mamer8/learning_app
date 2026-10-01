import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../localization/app_localizations.dart';
import '../../features/playground/interactive_editor_screen.dart';

/// كود بلوك احترافي بتصميم شبيه بمحررات الأكواد الحديثة
class CopyableCodeBlock extends StatefulWidget {
  const CopyableCodeBlock({
    required this.code,
    this.language = 'Dart',
    this.copiedMessage = 'تم نسخ الكود بنجاح!',
    this.copyTooltip = 'نسخ الكود',
    this.showLineNumbers = true,
    this.showPlaygroundAction = true,
    super.key,
  });

  final String code;
  final String language;
  final String copiedMessage;
  final String copyTooltip;
  final bool showLineNumbers;
  final bool showPlaygroundAction;

  @override
  State<CopyableCodeBlock> createState() => _CopyableCodeBlockState();
}

class _CopyableCodeBlockState extends State<CopyableCodeBlock> {
  bool _isCopied = false;

  Future<void> _handleCopy() async {
    await Clipboard.setData(ClipboardData(text: widget.code));
    if (!mounted) return;
    setState(() => _isCopied = true);

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: Color(0xFF34D399),
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              widget.copiedMessage,
              style: const TextStyle(color: Colors.white, fontSize: 12.5),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF0F172A),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 1500),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Color(0xFF10B981), width: 0.8),
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _isCopied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final lines = widget.code.trimRight().split('\n');

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF070B14),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF1E293B), width: 1),
          boxShadow: const [
            BoxShadow(
              color: Color(0x22000000),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // شريط العنوان العلوي (Mac-Style Header)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: const BoxDecoration(
                color: Color(0xFF0D1424),
                borderRadius: BorderRadius.vertical(top: Radius.circular(11)),
                border: Border(bottom: BorderSide(color: Color(0xFF1E293B))),
              ),
              child: Row(
                children: [
                  // نقاط Mac الثلاث
                  Row(
                    children: [
                      Container(
                        width: 9,
                        height: 9,
                        decoration: const BoxDecoration(
                          color: Color(0xFFEF4444),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Container(
                        width: 9,
                        height: 9,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF59E0B),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Container(
                        width: 9,
                        height: 9,
                        decoration: const BoxDecoration(
                          color: Color(0xFF10B981),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  // لغة البرمجة
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      widget.language.toUpperCase(),
                      style: const TextStyle(
                        color: Color(0xFF5EEAD4),
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (widget.showPlaygroundAction) ...[
                    TextButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => InteractiveEditorScreen(
                              initialCode: widget.code,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.play_circle_outline_rounded,
                        size: 15,
                      ),
                      label: Text(
                        AppLocaleScope.of(context).strings.t('playgroundTry'),
                        style: const TextStyle(fontSize: 10.5),
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF5EEAD4),
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        minimumSize: const Size(0, 30),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                    const SizedBox(width: 4),
                  ],
                  // زر النسخ السريع
                  InkWell(
                    onTap: _handleCopy,
                    borderRadius: BorderRadius.circular(6),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _isCopied
                            ? const Color(0xFF064E3B)
                            : const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: _isCopied
                              ? const Color(0xFF10B981)
                              : Colors.transparent,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _isCopied
                                ? Icons.check_rounded
                                : Icons.copy_rounded,
                            size: 13,
                            color: _isCopied
                                ? const Color(0xFF34D399)
                                : const Color(0xFF94A3B8),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _isCopied ? 'Copied' : 'Copy',
                            style: TextStyle(
                              color: _isCopied
                                  ? const Color(0xFF34D399)
                                  : const Color(0xFF94A3B8),
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // محتوى الكود مع أرقام الأسطر
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.showLineNumbers)
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: List.generate(
                          lines.length,
                          (i) => Text(
                            '${i + 1}',
                            style: GoogleFonts.jetBrainsMono(
                              color: const Color(0xFF475569),
                              fontSize: 11.5,
                              height: 1.45,
                            ),
                          ),
                        ),
                      ),
                    ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: lines.map((line) {
                      return Text(
                        line.isEmpty ? ' ' : line,
                        style: GoogleFonts.jetBrainsMono(
                          color: const Color(0xFFE2E8F0),
                          fontSize: 11.5,
                          height: 1.45,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
