// lib/main.dart

import 'package:ai_scribe_copilot/providers/patient_provider.dart';
import 'package:ai_scribe_copilot/screens/patient_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ai_scribe_copilot/background_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize the background service
  await initializeService();

  runApp(
    ChangeNotifierProvider(
      create: (context) => PatientProvider(),
      child: const MyApp(),
    ),
  );
}

// ... rest of the file remains the same
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Scribe Copilot',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const PatientListScreen(),
    );
  }
}