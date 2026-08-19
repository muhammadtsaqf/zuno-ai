import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/chat_message.dart';
import '../config/app_config.dart';

class ApiService {
  // Custom Vercel Backend URL (can be updated by user in Settings, defaults to AppConfig.defaultVercelBackendUrl)
  static String vercelUrl = AppConfig.defaultVercelBackendUrl;

  static Future<String> sendMessage({
    required List<ChatMessage> history,
    required String selectedModel,
    String? customVercelUrl,
  }) async {
    final String targetUrl = (customVercelUrl != null && customVercelUrl.trim().isNotEmpty)
        ? customVercelUrl.trim()
        : (vercelUrl.isNotEmpty ? vercelUrl : AppConfig.defaultVercelBackendUrl);

    return _sendViaVercelProxy(history, selectedModel, targetUrl);
  }

  static Future<String> _sendViaVercelProxy(
    List<ChatMessage> history,
    String model,
    String backendUrl,
  ) async {
    String endpoint = backendUrl.endsWith('/')
        ? '${backendUrl}api/chat'
        : '$backendUrl/api/chat';

    final messagesPayload = history.map((m) => m.toApiFormat()).toList();

    final response = await http.post(
      Uri.parse(endpoint),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'model': model,
        'messages': messagesPayload,
      }),
    ).timeout(const Duration(seconds: 65));

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      if (data['choices'] != null && data['choices'].isNotEmpty) {
        return data['choices'][0]['message']['content'] ?? 'Maaf, Zuno tidak dapat memproses jawaban.';
      }
      return 'Maaf, format balasan AI tidak valid.';
    } else {
      final errData = jsonDecode(response.body);
      throw Exception(errData['error'] ?? 'Server Error (${response.statusCode})');
    }
  }

  static Future<void> syncSessionToCloud({
    required String userId,
    required dynamic sessionJson,
  }) async {
    final String targetUrl = vercelUrl.isNotEmpty ? vercelUrl : AppConfig.defaultVercelBackendUrl;
    try {
      String endpoint = targetUrl.endsWith('/') ? '${targetUrl}api/sessions' : '$targetUrl/api/sessions';
      await http.post(
        Uri.parse(endpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'session': sessionJson,
        }),
      ).timeout(const Duration(seconds: 15));
    } catch (e) {
      // Ignore background sync errors
    }
  }

  static Future<List<dynamic>> fetchSessionsFromCloud(String userId) async {
    final String targetUrl = vercelUrl.isNotEmpty ? vercelUrl : AppConfig.defaultVercelBackendUrl;
    try {
      String endpoint = targetUrl.endsWith('/')
          ? '${targetUrl}api/sessions?userId=$userId'
          : '$targetUrl/api/sessions?userId=$userId';
      final res = await http.get(Uri.parse(endpoint)).timeout(const Duration(seconds: 15));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return data['sessions'] ?? [];
      }
    } catch (e) {
      // Fallback
    }
    return [];
  }

  static Future<void> deleteSessionFromCloud(String userId, String sessionId) async {
    final String targetUrl = vercelUrl.isNotEmpty ? vercelUrl : AppConfig.defaultVercelBackendUrl;
    try {
      String endpoint = targetUrl.endsWith('/')
          ? '${targetUrl}api/sessions?userId=$userId&sessionId=$sessionId'
          : '$targetUrl/api/sessions?userId=$userId&sessionId=$sessionId';
      await http.delete(Uri.parse(endpoint)).timeout(const Duration(seconds: 15));
    } catch (_) {}
  }

  static Future<void> clearAllSessionsFromCloud(String userId) async {
    final String targetUrl = vercelUrl.isNotEmpty ? vercelUrl : AppConfig.defaultVercelBackendUrl;
    try {
      String endpoint = targetUrl.endsWith('/')
          ? '${targetUrl}api/sessions?userId=$userId&clearAll=true'
          : '$targetUrl/api/sessions?userId=$userId&clearAll=true';
      await http.delete(Uri.parse(endpoint)).timeout(const Duration(seconds: 15));
    } catch (_) {}
  }
}
