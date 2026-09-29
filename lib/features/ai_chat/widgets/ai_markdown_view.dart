import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markdown/markdown.dart' as md;
import '../../../core/widgets/copyable_code_block.dart';

/// مفسر Markdown مخصص للمساعد الذكي مع دعم تنسيق الأكواد والجداول
class AiMarkdownView extends StatelessWidget {
  const AiMarkdownView({
    required this.data,
    this.selectable = true,
    super.key,
  });

  final String data;
  final bool selectable;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final baseStyle = GoogleFonts.cairo(
      color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF1E293B),
      fontSize: 13,
      height: 1.6,
      letterSpacing: 0.2,
    );

    return MarkdownBody(
      data: data,
      selectable: selectable,
      builders: {
        'code': _CodeElementBuilder(),
      },
      styleSheet: MarkdownStyleSheet(
        p: baseStyle,
        pPadding: const EdgeInsets.only(bottom: 8),
        h1: baseStyle.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          color: const Color(0xFF5EEAD4),
          height: 1.4,
        ),
        h1Padding: const EdgeInsets.only(top: 10, bottom: 6),
        h2: baseStyle.copyWith(
          fontSize: 14.5,
          fontWeight: FontWeight.w800,
          color: const Color(0xFF38BDF8),
          height: 1.4,
        ),
        h2Padding: const EdgeInsets.only(top: 8, bottom: 4),
        h3: baseStyle.copyWith(
          fontSize: 13.5,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF93C5FD),
        ),
        h3Padding: const EdgeInsets.only(top: 6, bottom: 4),
        strong: baseStyle.copyWith(
          fontWeight: FontWeight.w800,
          color: const Color(0xFF5EEAD4),
        ),
        em: baseStyle.copyWith(
          fontStyle: FontStyle.italic,
          color: const Color(0xFFFDE68A),
        ),
        code: const TextStyle(
          color: Color(0xFF38BDF8),
          backgroundColor: Color(0xFF1E293B),
          fontFamily: 'monospace',
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        codeblockPadding: EdgeInsets.zero,
        codeblockDecoration: const BoxDecoration(),
        blockquote: baseStyle.copyWith(
          color: const Color(0xFF94A3B8),
          fontStyle: FontStyle.italic,
        ),
        blockquoteDecoration: BoxDecoration(
          color: const Color(0xFF0F172A),
          borderRadius: BorderRadius.circular(8),
          border: const Border(
            right: BorderSide(color: Color(0xFF14B8A6), width: 3),
          ),
        ),
        blockquotePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        listBullet: baseStyle.copyWith(
          color: const Color(0xFF14B8A6),
          fontWeight: FontWeight.bold,
        ),
        listBulletPadding: const EdgeInsets.only(right: 6),
        listIndent: 16,
        tableBorder: TableBorder.all(
          color: const Color(0xFF334155),
          width: 0.8,
          borderRadius: BorderRadius.circular(6),
        ),
        tableHead: const TextStyle(
          color: Color(0xFF5EEAD4),
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        tableBody: const TextStyle(
          color: Color(0xFFCBD5E1),
          fontSize: 11.5,
        ),
        tableCellsPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      ),
    );
  }
}

class _CodeElementBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfterWithContext(
    BuildContext context,
    md.Element element,
    TextStyle? preferredStyle,
    TextStyle? parentStyle,
  ) {
    final language = element.attributes['class']?.replaceFirst('language-', '') ?? 'Dart';
    final code = element.textContent;

    // إذا كان كود مضمن (Inline code)، نتركه للتنسيق الافتراضي
    if (!element.textContent.contains('\n') && (element.attributes['class'] == null || element.attributes['class']!.isEmpty)) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: const Color(0xFF334155), width: 0.6),
        ),
        child: Text(
          code,
          style: const TextStyle(
            color: Color(0xFF38BDF8),
            fontFamily: 'monospace',
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return CopyableCodeBlock(
      code: code,
      language: language.isEmpty ? 'Dart' : language,
    );
  }
}
