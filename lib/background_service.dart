import 'dart:async';
import 'dart:ui';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';

String _formatDuration(int seconds) {
  final hours = (seconds ~/ 3600).toString().padLeft(2, '0');
  final minutes = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
  final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
  return '$hours:$minutes:$remainingSeconds';
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  final recorder = AudioRecorder();
  Timer? timer;
  int recordDuration = 0;

  service.on('start').listen((event) async {
    WakelockPlus.enable();
    final dir = await getApplicationDocumentsDirectory();
    final path =
        '${dir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';

    await recorder.start(const RecordConfig(), path: path);

    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      recordDuration++;
      final durationString = _formatDuration(recordDuration);

      // ✅ THIS is how you update notification in v5
      if (service is AndroidServiceInstance) {
        service.setForegroundNotificationInfo(
          title: "Recording...",
          content: "Duration: $durationString",
        );
      }

      service.invoke('update', {
        'duration': recordDuration,
        'isRecording': true,
      });
    });
  });

  service.on('stop').listen((event) async {
    WakelockPlus.disable();
    timer?.cancel();
    await recorder.stop();

    if (service is AndroidServiceInstance) {
      service.setForegroundNotificationInfo(
        title: "AI Scribe",
        content: "Recording stopped",
      );
    }

    service.invoke('update', {'isRecording': false});
  });
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: false,
      isForegroundMode: true, // 👈 REQUIRED
      notificationChannelId: 'my_app_channel',
      initialNotificationTitle: 'AI Scribe',
      initialNotificationContent: 'Idle',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(),
  );
}
