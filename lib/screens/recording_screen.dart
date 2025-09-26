// lib/screens/recording_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

class RecordingScreen extends StatefulWidget {
  const RecordingScreen({super.key});

  @override
  State<RecordingScreen> createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingScreen> {
  // Recorder instance
  final AudioRecorder _audioRecorder = AudioRecorder();
  
  // State variables
  bool _isRecording = false;
  bool _isPaused = false;
  int _recordDuration = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw 'Microphone permission not granted';
    }
  }

  @override
  void dispose() {
    // Make sure to dispose of the recorder and timer
    _timer?.cancel();
    _audioRecorder.dispose();
    super.dispose();
  }

  // --- Recording Logic ---

  Future<void> _startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final dir = await getApplicationDocumentsDirectory();
        final path = '${dir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
        
        // Start recording to the given path
        await _audioRecorder.start(const RecordConfig(), path: path);

        setState(() {
          _isRecording = true;
          _recordDuration = 0;
        });

        // Start a timer to update the UI
        _startTimer();
      }
    } catch (e) {
      print('Error starting recording: $e');
    }
  }

  Future<void> _stopRecording() async {
    try {
      _timer?.cancel();
      final path = await _audioRecorder.stop();

      setState(() {
        _isRecording = false;
        _isPaused = false;
      });

      print('Recording stopped! File saved at: $path');
      // Here you can handle the saved file, e.g., prepare it for upload
    } catch (e) {
      print('Error stopping recording: $e');
    }
  }

  Future<void> _pauseRecording() async {
    try {
      _timer?.cancel();
      await _audioRecorder.pause();
      setState(() => _isPaused = true);
    } catch (e) {
      print('Error pausing recording: $e');
    }
  }

  Future<void> _resumeRecording() async {
    try {
      await _audioRecorder.resume();
      setState(() => _isPaused = false);
      _startTimer();
    } catch (e) {
      print('Error resuming recording: $e');
    }
  }

  void _startTimer() {
    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() => _recordDuration++);
    });
  }

  // --- UI ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Session'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Patient Name Here', // TODO: Pass patient data
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                _formatDuration(_recordDuration),
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w300),
              ),
              const SizedBox(height: 32),
              // Placeholder for audio visualizer
              Container(
                height: 100,
                color: Colors.grey.shade200,
                width: double.infinity,
                child: const Center(child: Text('Audio Visualizer Area')),
              ),
              const SizedBox(height: 48),
              _buildControls(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Stop Button
        IconButton(
          icon: const Icon(Icons.stop_circle),
          iconSize: 60,
          color: _isRecording ? Colors.grey.shade700 : Colors.grey.shade400,
          onPressed: _isRecording ? _stopRecording : null,
        ),
        const SizedBox(width: 20),
        // Record/Pause/Resume Button
        if (!_isRecording)
          _buildRecordButton()
        else
          _buildPauseResumeButton(),
      ],
    );
  }

  Widget _buildRecordButton() {
    return IconButton(
      icon: const Icon(Icons.mic),
      iconSize: 80,
      color: Colors.deepPurple,
      onPressed: _startRecording,
    );
  }
  
  Widget _buildPauseResumeButton() {
    return IconButton(
      icon: Icon(_isPaused ? Icons.play_circle : Icons.pause_circle),
      iconSize: 80,
      color: Colors.red,
      onPressed: _isPaused ? _resumeRecording : _pauseRecording,
    );
  }

  String _formatDuration(int seconds) {
    final hours = (seconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$remainingSeconds';
  }
}