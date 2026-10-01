import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../core/localization/app_localizations.dart';

class InteractiveEditorScreen extends StatefulWidget {
  const InteractiveEditorScreen({required this.initialCode, super.key});

  final String initialCode;

  @override
  State<InteractiveEditorScreen> createState() =>
      _InteractiveEditorScreenState();
}

class _InteractiveEditorScreenState extends State<InteractiveEditorScreen> {
  late final TextEditingController _codeController;

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController(text: widget.initialCode);
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _copyCode() async {
    await Clipboard.setData(ClipboardData(text: _codeController.text));
    if (!mounted) return;
    _showMessage(AppLocaleScope.of(context).strings.t('playgroundCodeCopied'));
  }

  Future<void> _openDartPad() async {
    await Clipboard.setData(ClipboardData(text: _codeController.text));
    if (!mounted) return;

    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => _DartPadScreen(code: _codeController.text),
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocaleScope.of(context);
    final strings = locale.strings;

    return Directionality(
      textDirection: locale.textDirection,
      child: Scaffold(
        appBar: AppBar(title: Text(strings.t('playgroundTitle'))),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF172033),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFF24324A)),
                  ),
                  child: Text(
                    strings.t('playgroundInstructions'),
                    style: const TextStyle(
                      color: Color(0xFFCBD5E1),
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF070B14),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFF24324A)),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: TextField(
                        controller: _codeController,
                        expands: true,
                        minLines: null,
                        maxLines: null,
                        textAlignVertical: TextAlignVertical.top,
                        keyboardType: TextInputType.multiline,
                        autocorrect: false,
                        enableSuggestions: false,
                        style: const TextStyle(
                          color: Color(0xFFE2E8F0),
                          fontFamily: 'monospace',
                          fontSize: 13,
                          height: 1.5,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          filled: false,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: _openDartPad,
                  icon: const Icon(Icons.open_in_new_rounded),
                  label: Text(strings.t('playgroundOpenDartPad')),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: _copyCode,
                  icon: const Icon(Icons.copy_rounded),
                  label: Text(strings.t('playgroundCopyCode')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DartPadScreen extends StatefulWidget {
  const _DartPadScreen({required this.code});

  final String code;

  @override
  State<_DartPadScreen> createState() => _DartPadScreenState();
}

class _DartPadScreenState extends State<_DartPadScreen> {
  WebViewController? _webViewController;
  Timer? _loadTimeout;
  bool _isLoadingDartPad = true;
  bool _hasLoadError = false;

  bool get _isWebViewSupported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.macOS);

  @override
  void initState() {
    super.initState();
    if (!_isWebViewSupported) {
      _isLoadingDartPad = false;
      _hasLoadError = true;
      return;
    }

    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF0B1220))
      ..addJavaScriptChannel(
        'DartPadBridge',
        onMessageReceived: _onDartPadMessage,
      );
    _loadDartPad();
  }

  @override
  void dispose() {
    _loadTimeout?.cancel();
    super.dispose();
  }

  void _loadDartPad() {
    final controller = _webViewController;
    if (controller == null) return;

    _loadTimeout?.cancel();
    setState(() {
      _isLoadingDartPad = true;
      _hasLoadError = false;
    });
    _loadTimeout = Timer(const Duration(seconds: 30), () {
      if (!mounted || !_isLoadingDartPad) return;
      setState(() {
        _isLoadingDartPad = false;
        _hasLoadError = true;
      });
    });
    controller.loadHtmlString(_buildDartPadEmbedHtml(widget.code));
  }

  void _onDartPadMessage(JavaScriptMessage message) {
    if (message.message != 'ready' || !mounted) return;
    _loadTimeout?.cancel();
    setState(() {
      _isLoadingDartPad = false;
      _hasLoadError = false;
    });
  }

  String _buildDartPadEmbedHtml(String code) {
    final encodedCode = jsonEncode(code).replaceAll('<', r'\u003C');
    return '''
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <style>
    html, body, iframe { width: 100%; height: 100%; margin: 0; border: 0; }
    body { overflow: hidden; background: #0b1220; }
  </style>
</head>
<body>
  <iframe id="dartpad" title="DartPad"
    src="https://dartpad.dev/?embed=true&theme=dark"></iframe>
  <script>
    const dartpad = document.getElementById('dartpad');
    const sourceCode = $encodedCode;
    let codeSent = false;

    window.addEventListener('message', (event) => {
      const isDartPad = event.origin === 'https://dartpad.dev' ||
        event.origin === 'https://preview.dartpad.dev';
      if (!isDartPad || event.source !== dartpad.contentWindow) return;
      if (!event.data || event.data.type !== 'ready' || codeSent) return;

      codeSent = true;
      DartPadBridge.postMessage('ready');
      event.source.postMessage(
        { type: 'sourceCode', sourceCode: sourceCode },
        event.origin
      );
    });
  </script>
</body>
</html>
''';
  }

  Future<void> _copyCode() async {
    await Clipboard.setData(ClipboardData(text: widget.code));
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            AppLocaleScope.of(context).strings.t('playgroundPasteInDartPad'),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocaleScope.of(context);
    final strings = locale.strings;

    return Directionality(
      textDirection: locale.textDirection,
      child: Scaffold(
        appBar: AppBar(
          title: Text(strings.t('playgroundDartPadTitle')),
          actions: [
            IconButton(
              tooltip: strings.t('playgroundCopyCode'),
              onPressed: _copyCode,
              icon: const Icon(Icons.copy_rounded),
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: const Color(0xFF172033),
              child: Text(
                strings.t('playgroundDartPadInstructions'),
                style: const TextStyle(
                  color: Color(0xFFCBD5E1),
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  if (_webViewController case final controller?)
                    WebViewWidget(controller: controller),
                  if (_isLoadingDartPad)
                    const Center(child: CircularProgressIndicator()),
                  if (_hasLoadError)
                    ColoredBox(
                      color: const Color(0xFF0B1220),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                strings.t(
                                  _isWebViewSupported
                                      ? 'playgroundLoadFailed'
                                      : 'playgroundUnsupportedPlatform',
                                ),
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 16),
                              FilledButton(
                                onPressed: _isWebViewSupported
                                    ? _loadDartPad
                                    : null,
                                child: Text(strings.t('retry')),
                              ),
                            ],
                          ),
                        ),
                      ),
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
