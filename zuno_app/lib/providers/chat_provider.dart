import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/chat_message.dart';
import '../models/chat_session.dart';
import '../models/ai_models.dart';
import '../services/api_service.dart';

class ChatProvider with ChangeNotifier {
  List<ChatSession> _sessions = [];
  String? _currentSessionId;
  bool _isLoading = false;
  String _vercelBackendUrl = '';
  String _selectedModel = AiModels.zunoPro;
  final Uuid _uuid = const Uuid();

  List<ChatSession> get sessions => _sessions;
  String? get currentSessionId => _currentSessionId;
  bool get isLoading => _isLoading;
  String get vercelBackendUrl => _vercelBackendUrl;
  String get selectedModel => _selectedModel;

  ChatSession? get currentSession {
    if (_currentSessionId == null) return null;
    try {
      return _sessions.firstWhere((s) => s.id == _currentSessionId);
    } catch (_) {
      return null;
    }
  }

  List<ChatMessage> get currentMessages => currentSession?.messages ?? [];

  ChatProvider() {
    loadFromPrefs();
  }

  Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _vercelBackendUrl = prefs.getString('vercel_url') ?? '';
    _selectedModel = prefs.getString('selected_model') ?? AiModels.zunoPro;
    ApiService.vercelUrl = _vercelBackendUrl;

    final String? sessionsRaw = prefs.getString('chat_sessions');
    if (sessionsRaw != null) {
      try {
        final List decoded = jsonDecode(sessionsRaw);
        _sessions = decoded.map((item) => ChatSession.fromJson(item)).toList();
      } catch (e) {
        debugPrint('Error loading sessions: $e');
      }
    }

    if (_sessions.isEmpty) {
      createNewSession();
    } else {
      _currentSessionId = _sessions.first.id;
    }
    notifyListeners();
  }

  Future<void> saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(_sessions.map((s) => s.toJson()).toList());
    await prefs.setString('chat_sessions', encoded);
    await prefs.setString('vercel_url', _vercelBackendUrl);
    await prefs.setString('selected_model', _selectedModel);
  }

  void setVercelUrl(String url) {
    _vercelBackendUrl = url.trim();
    ApiService.vercelUrl = _vercelBackendUrl;
    saveToPrefs();
    notifyListeners();
  }

  void setSelectedModel(String modelId) {
    _selectedModel = modelId;
    saveToPrefs();
    notifyListeners();
  }

  void createNewSession({String? userId}) {
    final newSession = ChatSession(
      id: _uuid.v4(),
      title: 'Percakapan Baru',
      createdAt: DateTime.now(),
      messages: [
        ChatMessage(
          id: _uuid.v4(),
          content: 'Halo! Saya **Zuno**, AI Assistant cerdas ciptaan **zzamcode (Muhammad Tsaqif Noor Az Zamil)**. Ada yang bisa saya bantu hari ini?',
          role: MessageRole.assistant,
          timestamp: DateTime.now(),
        )
      ],
    );
    _sessions.insert(0, newSession);
    _currentSessionId = newSession.id;
    saveToPrefs();

    if (userId != null && userId.isNotEmpty) {
      ApiService.syncSessionToCloud(userId: userId, sessionJson: newSession.toJson());
    }

    notifyListeners();
  }

  void selectSession(String sessionId) {
    _currentSessionId = sessionId;
    notifyListeners();
  }

  void deleteSession(String sessionId, {String? userId}) {
    _sessions.removeWhere((s) => s.id == sessionId);
    if (_currentSessionId == sessionId) {
      _currentSessionId = _sessions.isNotEmpty ? _sessions.first.id : null;
    }

    if (userId != null && userId.isNotEmpty) {
      ApiService.deleteSessionFromCloud(userId, sessionId);
    }

    if (_sessions.isEmpty) {
      createNewSession(userId: userId);
    } else {
      saveToPrefs();
      notifyListeners();
    }
  }

  void clearAllSessions({String? userId}) {
    _sessions.clear();
    _currentSessionId = null;
    if (userId != null && userId.isNotEmpty) {
      ApiService.clearAllSessionsFromCloud(userId);
    }
    createNewSession(userId: userId);
  }

  Future<void> sendMessage(String text, {String? userId}) async {
    if (text.trim().isEmpty || _currentSessionId == null) return;

    final userMsg = ChatMessage(
      id: _uuid.v4(),
      content: text.trim(),
      role: MessageRole.user,
      timestamp: DateTime.now(),
    );

    final sessionIndex = _sessions.indexWhere((s) => s.id == _currentSessionId);
    if (sessionIndex == -1) return;

    final session = _sessions[sessionIndex];
    session.messages.add(userMsg);

    // Update title if first message
    if (session.messages.where((m) => m.role == MessageRole.user).length == 1) {
      String newTitle = text.trim();
      if (newTitle.length > 25) {
        newTitle = '${newTitle.substring(0, 25)}...';
      }
      _sessions[sessionIndex] = ChatSession(
        id: session.id,
        title: newTitle,
        createdAt: session.createdAt,
        messages: session.messages,
      );
    }

    _isLoading = true;
    notifyListeners();

    try {
      final aiResponseText = await ApiService.sendMessage(
        history: session.messages,
        selectedModel: _selectedModel,
        customVercelUrl: _vercelBackendUrl,
      );

      final aiMsg = ChatMessage(
        id: _uuid.v4(),
        content: aiResponseText,
        role: MessageRole.assistant,
        timestamp: DateTime.now(),
      );

      session.messages.add(aiMsg);
    } catch (e) {
      final errorMsg = ChatMessage(
        id: _uuid.v4(),
        content: '⚠️ **Gagal terhubung dengan Zuno AI:**\n${e.toString()}',
        role: MessageRole.assistant,
        timestamp: DateTime.now(),
      );
      session.messages.add(errorMsg);
    } finally {
      _isLoading = false;
      saveToPrefs();
      if (userId != null && userId.isNotEmpty) {
        ApiService.syncSessionToCloud(userId: userId, sessionJson: session.toJson());
      }
      notifyListeners();
    }
  }
}
