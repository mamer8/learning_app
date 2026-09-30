import 'package:flutter/material.dart';
import '../../core/core.dart';
import '../../core/localization/app_localizations.dart';
import '../ai_chat/widgets/contextual_ai_sheet.dart';

/// شاشة مختبر Platform Channels و Native Bridge
class PlatformChannelsScreen extends StatefulWidget {
  const PlatformChannelsScreen({super.key});

  @override
  State<PlatformChannelsScreen> createState() => _PlatformChannelsScreenState();
}

class _PlatformChannelsScreenState extends State<PlatformChannelsScreen> {
  final List<String> _bridgeLogs = [];
  bool _isNativeLoading = false;
  final int _simulatedBattery = 86;
  bool _isListeningSensor = false;
  String _lastMethodInvoked = 'getBatteryLevel';

  void _openAiAssistant(bool isArabic) {
    ContextualAiSheet.show(
      context,
      topicTitle: isArabic ? 'مختبر جسر المنصات (Platform Channels & FFI)' : 'Platform Channels & Native Bridge Lab',
      topicCode: _buildDynamicChannelsCode(isArabic),
      levelTitle: 'مستوى خبير (Senior Architecture & Native)',
      isArabic: isArabic,
    );
  }

  String _buildDynamicChannelsCode(bool isArabic) {
    return '// === 1. MethodChannel (Dart <-> Native Android/iOS) ===\n'
        'const platform = MethodChannel("com.example.learning/native_channel");\n\n'
        '// استدعاء آخر دالة: "$_lastMethodInvoked"\n'
        'Future<void> invokePlatformMethod() async {\n'
        '  try {\n'
        '    final result = await platform.invokeMethod<dynamic>(\n'
        '      "$_lastMethodInvoked",\n'
        '      {"timestamp": DateTime.now().millisecondsSinceEpoch},\n'
        '    );\n'
        '    print("Native Result: \$result");\n'
        '  } on PlatformException catch (e) {\n'
        '    print("Bridge Error: \${e.message}");\n'
        '  }\n'
        '}\n\n'
        '// === 2. EventChannel (Real-time Sensor Stream) ===\n'
        '// حالة الاستماع الحالية: ${_isListeningSensor ? "نشط (Listening...)" : "متوقف (Paused)"}\n'
        'const sensorEventChannel = EventChannel("com.example.learning/gyroscope_stream");\n'
        'StreamSubscription? _sensorSub;\n\n'
        'void toggleSensorStream() {\n'
        '${_isListeningSensor ? "  _sensorSub = sensorEventChannel.receiveBroadcastStream().listen((data) {\n    print(\"Live Sensor: \$data\");\n  });" : "  _sensorSub?.cancel();\n  _sensorSub = null;"}\n'
        '}';
  }

  void _invokeMethodChannel(String method) async {
    setState(() {
      _lastMethodInvoked = method;
      _isNativeLoading = true;
      _bridgeLogs.insert(0, '📤 [MethodChannel] Invoking native method: "$method" via BinaryMessenger...');
    });

    await Future.delayed(const Duration(milliseconds: 600));

    setState(() {
      _isNativeLoading = false;
      if (method == 'getBatteryLevel') {
        _bridgeLogs.insert(0, '📥 [Native Kotlin/Swift] Returned Battery Level: $_simulatedBattery%');
      } else if (method == 'showNativeToast') {
        _bridgeLogs.insert(0, '📥 [Native Android/iOS] Toast shown successfully on native UI Window.');
      } else if (method == 'getDeviceInfo') {
        _bridgeLogs.insert(0, '📥 [Native OS] Device: Pixel 8 Pro | Android 14 (API 34) | ABI: arm64-v8a');
      }
    });
  }

  void _toggleEventChannel() {
    setState(() {
      _isListeningSensor = !_isListeningSensor;
      if (_isListeningSensor) {
        _bridgeLogs.insert(0, '📡 [EventChannel] Subscribed to native Gyroscope sensor stream.');
      } else {
        _bridgeLogs.insert(0, '🛑 [EventChannel] Unsubscribed & native sensor listener stopped.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocaleScope.of(context);
    final isArabic = locale.isArabic;

    return Directionality(
      textDirection: locale.textDirection,
      child: Scaffold(
        appBar: AppBar(
          title: Text(isArabic ? 'مختبر جسر المنصات (Platform Channels)' : 'Platform Channels & FFI Lab'),
          actions: [
            IconButton(
              icon: const Icon(Icons.auto_awesome, color: Color(0xFF22D3EE)),
              tooltip: isArabic ? 'اسأل الذكاء الاصطناعي عن Platform Channels' : 'Ask AI Copilot',
              onPressed: () => _openAiAssistant(isArabic),
            ),
            IconButton(
              icon: const Icon(Icons.clear_all_rounded),
              onPressed: () => setState(() => _bridgeLogs.clear()),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: const Color(0xFF0891B2),
          foregroundColor: Colors.white,
          icon: const Icon(Icons.auto_awesome),
          label: Text(
            isArabic ? 'اسأل الـ AI عن Native Bridge' : 'Ask Native AI',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          onPressed: () => _openAiAssistant(isArabic),
        ),
        body: ResponsiveContentWrapper(
          maxWidth: 1200,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
            children: [
              _buildIntroCard(isArabic),
              16.heightBox,

              // 1. MethodChannel Section
              _buildMethodChannelSection(isArabic),
              16.heightBox,

              // 2. EventChannel Section
              _buildEventChannelSection(isArabic),
              16.heightBox,

              // 3. سجلات الباكيتات عبر الجسر (Bridge Packet Logs)
              _buildPacketLogs(isArabic),
              16.heightBox,

              // 4. Dynamic Code Snippet Card
              _buildCodeSnippetCard(isArabic),
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
        border: Border.all(color: const Color(0xFF06B6D4).withValues(alpha: 0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF06B6D4).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.settings_input_component_rounded, color: Color(0xFF22D3EE), size: 24),
          ),
          12.widthBox,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isArabic ? 'التواصل مع Kotlin و Swift و C++ (Native Bridge)' : 'Bridging Flutter with Native OS',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                ),
                4.heightBox,
                Text(
                  isArabic
                      ? 'يستخدم Flutter تقنية BinaryMessenger لنقل الرسائل بصيغة بايتات مشفرة (StandardMessageCodec) بين كود Dart والأنظمة الأصلية Android / iOS.'
                      : 'Flutter talks to host platforms via asynchronous binary messaging channels and zero-overhead Dart FFI.',
                  style: const TextStyle(fontSize: 12, color: Colors.white70, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMethodChannelSection(bool isArabic) {
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
          Row(
            children: [
              const Icon(Icons.call_made_rounded, color: Color(0xFF22D3EE), size: 18),
              8.widthBox,
              Text(
                isArabic ? '1. استدعاءات MethodChannel الثنائية' : '1. MethodChannel Invocations',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
              ),
            ],
          ),
          8.heightBox,
          Text(
            isArabic
                ? 'استدعاء دالة محددة في الطرف الأصلي وانتظار النتيجة مثل قراءة نسبة البطارية الحقيقية أو إظهار نافذة نظام.'
                : 'Invoke specific platform methods asynchronously and await serialized return values.',
            style: const TextStyle(fontSize: 11.5, color: Colors.white70),
          ),
          12.heightBox,

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0891B2)),
                onPressed: _isNativeLoading ? null : () => _invokeMethodChannel('getBatteryLevel'),
                icon: const Icon(Icons.battery_charging_full_rounded, color: Colors.white, size: 16),
                label: Text(isArabic ? 'فحص نسبة البطارية' : 'Get Battery Level', style: const TextStyle(color: Colors.white, fontSize: 12)),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0284C7)),
                onPressed: _isNativeLoading ? null : () => _invokeMethodChannel('getDeviceInfo'),
                icon: const Icon(Icons.phone_android_rounded, color: Colors.white, size: 16),
                label: Text(isArabic ? 'معلومات العتاد (OS Info)' : 'Get Device Info', style: const TextStyle(color: Colors.white, fontSize: 12)),
              ),
              OutlinedButton.icon(
                onPressed: _isNativeLoading ? null : () => _invokeMethodChannel('showNativeToast'),
                icon: const Icon(Icons.message_rounded, size: 16),
                label: Text(isArabic ? 'إظهار Native Toast' : 'Native Toast', style: const TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEventChannelSection(bool isArabic) {
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
          Row(
            children: [
              const Icon(Icons.sensors_rounded, color: Color(0xFF10B981), size: 18),
              8.widthBox,
              Text(
                isArabic ? '2. بث تدفق البيانات الحية بـ EventChannel' : '2. EventChannel Continuous Streams',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
              ),
            ],
          ),
          8.heightBox,
          Text(
            isArabic
                ? 'استقبال تدفق مستمر من الأحداث مثل حساسات التسارع (Accelerometer) أو تغيرات حالة الشبكة.'
                : 'Listen to continuous streams of platform events (sensor data, connectivity changes).',
            style: const TextStyle(fontSize: 11.5, color: Colors.white70),
          ),
          12.heightBox,

          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: _isListeningSensor ? const Color(0xFFDC2626) : const Color(0xFF059669),
            ),
            onPressed: _toggleEventChannel,
            icon: Icon(_isListeningSensor ? Icons.stop_rounded : Icons.sensors_rounded, color: Colors.white, size: 18),
            label: Text(
              _isListeningSensor
                  ? (isArabic ? 'إيقاف الاستماع للحساسات' : 'Stop Sensor Stream')
                  : (isArabic ? 'بدء تدفق بيانات الحساسات (Live Stream)' : 'Start Sensor Stream'),
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPacketLogs(bool isArabic) {
    return Container(
      padding: const EdgeInsets.all(14),
      height: 220,
      decoration: BoxDecoration(
        color: const Color(0xFF080D1A),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isArabic ? 'مفتش حزم BinaryMessenger الحية:' : 'Live BinaryMessenger Packet Inspector:',
                style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Colors.white70),
              ),
              if (_isNativeLoading)
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF22D3EE)),
                ),
            ],
          ),
          8.heightBox,
          Expanded(
            child: _bridgeLogs.isEmpty
                ? Center(
                    child: Text(
                      isArabic ? 'لا توجد رسائل متبادلة بعد' : 'No binary packets exchanged yet',
                      style: const TextStyle(color: Colors.white38, fontSize: 11),
                    ),
                  )
                : ListView.builder(
                    itemCount: _bridgeLogs.length,
                    itemBuilder: (context, i) {
                      final log = _bridgeLogs[i];
                      final isOut = log.startsWith('📤');
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text(
                          log,
                          style: TextStyle(
                            color: isOut ? const Color(0xFF38BDF8) : const Color(0xFF34D399),
                            fontSize: 11,
                            fontFamily: 'monospace',
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeSnippetCard(bool isArabic) {
    final code = _buildDynamicChannelsCode(isArabic);

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isArabic ? '💻 كود جسر الـ Platform Channels الحي:' : '💻 Dynamic Platform Channels Code:',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF0891B2).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text('Dynamic Live Code', style: TextStyle(color: Color(0xFF22D3EE), fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          10.heightBox,
          CopyableCodeBlock(
            code: code,
            copiedMessage: isArabic ? 'تم نسخ كود Platform Channels المحدث' : 'Platform Channels code copied',
            copyTooltip: isArabic ? 'نسخ الكود' : 'Copy Code',
          ),
        ],
      ),
    );
  }
}
