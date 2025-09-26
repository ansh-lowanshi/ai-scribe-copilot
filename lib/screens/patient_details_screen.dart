// lib/screens/patient_details_screen.dart

import 'package:ai_scribe_copilot/api/patient_model.dart';
import 'package:ai_scribe_copilot/providers/session_provider.dart';
import 'package:ai_scribe_copilot/screens/recording_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PatientDetailsScreen extends StatelessWidget {
  final Patient patient;

  const PatientDetailsScreen({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    // We provide the SessionProvider here, so it's fresh for each patient details screen.
    return ChangeNotifierProvider(
      create: (context) => SessionProvider()..fetchSessions(patient.id),
      child: Scaffold(
        appBar: AppBar(
          title: Text(patient.name),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                patient.name,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('ID: ${patient.id}'),
              const SizedBox(height: 24),
              const Text(
                'Past Sessions',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              Expanded(
                child: Consumer<SessionProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (provider.error != null) {
                      return Center(child: Text('Error: ${provider.error}'));
                    }
                    if (provider.sessions.isEmpty) {
                      return const Center(child: Text('No sessions found.'));
                    }
                    return ListView.builder(
                      itemCount: provider.sessions.length,
                      itemBuilder: (context, index) {
                        final session = provider.sessions[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            leading: const Icon(Icons.mic),
                            title: Text(session.title),
                            subtitle: Text('Date: ${session.date}'),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            // Navigate to the recording screen for this patient
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RecordingScreen()),
            );
          },
          label: const Text('New Session'),
          icon: const Icon(Icons.add),
        ),
      ),
    );
  }
}