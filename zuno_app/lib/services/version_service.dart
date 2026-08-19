import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';

class VersionInfo {
  final String latestVersion;
  final String minRequiredVersion;
  final String updateUrl;
  final String changelog;
  final bool forceUpdate;

  VersionInfo({
    required this.latestVersion,
    required this.minRequiredVersion,
    required this.updateUrl,
    required this.changelog,
    required this.forceUpdate,
  });

  factory VersionInfo.fromJson(Map<String, dynamic> json) {
    return VersionInfo(
      latestVersion: json['latestVersion'] ?? '1.0.0',
      minRequiredVersion: json['minRequiredVersion'] ?? '1.0.0',
      updateUrl: json['updateUrl'] ?? 'https://github.com/muhammadtsaqf/zuno-ai/releases',
      changelog: json['changelog'] ?? 'Pembaruan sistem dan keamanan.',
      forceUpdate: json['forceUpdate'] ?? false,
    );
  }
}

class VersionService {
  /// Compare two semantic version strings (e.g., "1.0.0" vs "1.0.1")
  /// Returns -1 if v1 < v2, 1 if v1 > v2, 0 if v1 == v2
  static int compareVersions(String v1, String v2) {
    List<int> parseVersion(String v) {
      return v.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    }

    final nums1 = parseVersion(v1);
    final nums2 = parseVersion(v2);
    final maxLength = nums1.length > nums2.length ? nums1.length : nums2.length;

    for (int i = 0; i < maxLength; i++) {
      final n1 = i < nums1.length ? nums1[i] : 0;
      final n2 = i < nums2.length ? nums2[i] : 0;
      if (n1 < n2) return -1;
      if (n1 > n2) return 1;
    }
    return 0;
  }

  /// Fetch version check from backend
  static Future<VersionInfo?> checkUpdate({String? customUrl}) async {
    final String baseUrl = (customUrl != null && customUrl.trim().isNotEmpty)
        ? customUrl.trim()
        : AppConfig.defaultVercelBackendUrl;

    try {
      final response = await http
          .get(Uri.parse('$baseUrl/api/version'))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return VersionInfo.fromJson(data);
      }
    } catch (_) {
      // If version endpoint fails or offline, return null to not block splash
    }
    return null;
  }
}
