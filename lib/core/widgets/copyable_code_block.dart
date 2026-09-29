import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CopyableCodeBlock extends StatelessWidget {
  const CopyableCodeBlock({
    required this.code,
    this.language = 'Dart',
    this.copiedMessage = 'Code copied',
    this.copyTooltip = 'Copy code',
    super.key,
  });

  final String code;
  final String language;
  final String copiedMessage;
  final String copyTooltip;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFF0B1220),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF334155)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 8, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      language,
                      style: const TextStyle(
                        color: Color(0xFF94A3B8),
                        fontWeight: FontWeight.w800,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: copyTooltip,
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(text: code));
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(copiedMessage),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    icon: const Icon(Icons.copy_rounded, size: 18),
                    color: const Color(0xFFE2E8F0),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFF334155)),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(14),
              child: Text(
                code,
                style: const TextStyle(
                  color: Color(0xFFE2E8F0),
                  fontFamily: 'monospace',
                  fontSize: 12,
                  height: 1.45,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
