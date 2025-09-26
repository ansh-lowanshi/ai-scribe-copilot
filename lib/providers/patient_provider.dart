// lib/providers/patient_provider.dart

import 'package:flutter/material.dart';
import 'package:ai_scribe_copilot/api/api_service.dart';
import 'package:ai_scribe_copilot/api/patient_model.dart';

class PatientProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  List<Patient> _patients = [];
  String? _error;

  // Getters to access the private state variables
  bool get isLoading => _isLoading;
  List<Patient> get patients => _patients;
  String? get error => _error;

  Future<void> fetchPatients() async {
    _isLoading = true;
    _error = null;
    notifyListeners(); // Notify UI to show loading indicator

    try {
      _patients = await _apiService.getPatients();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners(); // Notify UI to show data or error
    }
  }
}