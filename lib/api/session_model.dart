// lib/api/session_model.dart

class Session {
  final String id;
  final String date;
  final String title;

  Session({
    required this.id,
    required this.date,
    required this.title,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['id'] as String,
      date: json['date'] as String,
      title: json['session_title'] as String,
    );
  }
}