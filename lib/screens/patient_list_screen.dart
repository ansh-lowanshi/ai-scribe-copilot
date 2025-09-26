// lib/screens/patient_list_screen.dart

import 'package:ai_scribe_copilot/providers/patient_provider.dart';
import 'package:ai_scribe_copilot/screens/patient_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Convert to a StatefulWidget to use initState
class PatientListScreen extends StatefulWidget {
  const PatientListScreen({super.key});

  @override
  State<PatientListScreen> createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  @override
  void initState() {
    super.initState();
    // Trigger the fetch operation when the screen is first built
    // 'listen: false' is important inside initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PatientProvider>(context, listen: false).fetchPatients();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Use a Consumer widget to listen for changes in the provider
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Patients'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Consumer<PatientProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(child: Text('An error occurred: ${provider.error}'));
          }

          if (provider.patients.isEmpty) {
            return const Center(child: Text('No patients found.'));
          }

          // If we have data, build the list
          return ListView.builder(
            itemCount: provider.patients.length,
            itemBuilder: (context, index) {
              final patient = provider.patients[index];
              return ListTile(
                leading: const Icon(Icons.person),
                title: Text(patient.name), // Use real data
                subtitle: Text('ID: ${patient.id}'), // Use real data
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PatientDetailsScreen(patient: patient),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
