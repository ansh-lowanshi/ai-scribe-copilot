// lib/api/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ai_scribe_copilot/api/patient_model.dart';
import 'package:ai_scribe_copilot/api/session_model.dart'; // Import the new model

class ApiService {
  final String _baseUrl = "https://39c222ff-e5e5-4f68-a10a-79d0ac79faff.mock.pstmn.io";
  final String _userId = "user_123";

  Future<List<Patient>> getPatients() async {
    // ... (this method remains the same)
    final response = await http.get(Uri.parse('$_baseUrl/v1/patients?userId=$_userId'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> patientList = data['patients'];
      return patientList.map((json) => Patient.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load patients');
    }
  }

  // Add this new method
  Future<List<Session>> getPatientSessions(String patientId) async {
    final response = await http.get(Uri.parse('$_baseUrl/v1/fetch-session-by-patient/$patientId'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> sessionList = data['sessions'];
      return sessionList.map((json) => Session.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load sessions for patient $patientId');
    }
  }
}