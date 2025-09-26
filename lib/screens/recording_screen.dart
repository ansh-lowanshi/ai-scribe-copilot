// lib/screens/recording_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

class RecordingScreen extends StatefulWidget {
  const RecordingScreen({super.key});

  @override
  State<RecordingScreen> createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingScreen> {
  bool _isRecording = false;
  int _recordDuration = 0;
  final service = FlutterBackgroundService();

  @override
  void initState() {
    super.initState();
    // Listen for updates from the background service
    service.on('update').listen((event) {
      if (mounted) {
        setState(() {
          _isRecording = event!['isRecording'] ?? false;
          _recordDuration = event['duration'] ?? 0;
        });
      }
    });
  }

  void _toggleRecording() {
    if (_isRecording) {
      service.invoke('stop');
    } else {
      service.invoke('start');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recording Session'),
      ),
      body: Center(
        // ... UI code (Column, Text for patient, etc.)
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _formatDuration(_recordDuration),
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w300),
            ),
            const SizedBox(height: 48),
            IconButton(
              icon: Icon(_isRecording ? Icons.stop_circle : Icons.mic),
              iconSize: 80,
              color: _isRecording ? Colors.red : Colors.deepPurple,
              onPressed: _toggleRecording,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(int seconds) {
    // ... (same as before)
    final hours = (seconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$remainingSeconds';
  }
}