// lib/providers/session_provider.dart

import 'package:flutter/material.dart';
import 'package:ai_scribe_copilot/api/api_service.dart';
import 'package:ai_scribe_copilot/api/session_model.dart';

class SessionProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  List<Session> _sessions = [];
  String? _error;

  bool get isLoading => _isLoading;
  List<Session> get sessions => _sessions;
  String? get error => _error;

  Future<void> fetchSessions(String patientId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _sessions = await _apiService.getPatientSessions(patientId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}