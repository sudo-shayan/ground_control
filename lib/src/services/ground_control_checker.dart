import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/ground_control_config.dart';

/// Service responsible for fetching and parsing the remote GroundControl JSON configuration.
class GroundControlChecker {
  /// Fetches the remote JSON from [url].
  /// 
  /// Throws an exception if the fetch fails or parsing fails.
  static Future<GroundControlConfig> fetchConfig(
    String url, {
    Map<String, String>? headers,
  }) async {
    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return GroundControlConfig.fromJson(data);
      } else {
        throw HttpException('Failed to fetch config: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}

/// A utility class for semantic version comparison.
class GroundControlVersionComparator {
  /// Returns true if [version1] is greater than [version2].
  /// 
  /// Expects versions in format "major.minor.patch" (e.g. "1.2.3").
  static bool isGreater(String version1, String version2) {
    List<int> v1 = _parseVersion(version1);
    List<int> v2 = _parseVersion(version2);

    for (int i = 0; i < 3; i++) {
      if (v1[i] > v2[i]) return true;
      if (v1[i] < v2[i]) return false;
    }
    return false;
  }

  /// Returns true if [version1] is less than [version2].
  static bool isLess(String version1, String version2) {
    List<int> v1 = _parseVersion(version1);
    List<int> v2 = _parseVersion(version2);

    for (int i = 0; i < 3; i++) {
      if (v1[i] < v2[i]) return true;
      if (v1[i] > v2[i]) return false;
    }
    return false;
  }

  static List<int> _parseVersion(String version) {
    try {
      final parts = version.split('.').map(int.parse).toList();
      while (parts.length < 3) {
        parts.add(0);
      }
      return parts.take(3).toList();
    } catch (_) {
      return [0, 0, 0];
    }
  }
}
