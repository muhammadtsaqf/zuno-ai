import 'dart:io';
import 'package:path_provider/path_provider.dart';

class LocalStorageService {
  /// Mendapatkan direktori penyimpanan lokal terenkripsi internal HP
  static Future<Directory> getAppDocumentDir() async {
    return await getApplicationDocumentsDirectory();
  }

  /// Ekspor riwayat obrolan ke file teks lokal di HP pangguna
  static Future<File> exportChatSessionToFile(String sessionId, String content) async {
    final dir = await getAppDocumentDir();
    final file = File('${dir.path}/zuno_chat_$sessionId.txt');
    return await file.writeAsString(content);
  }

  /// Membaca file riwayat ekspor dari HP
  static Future<String?> readExportedChatFile(String sessionId) async {
    try {
      final dir = await getAppDocumentDir();
      final file = File('${dir.path}/zuno_chat_$sessionId.txt');
      if (await file.exists()) {
        return await file.readAsString();
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}