import 'package:shared_preferences/shared_preferences.dart';

/// Service for persisting the last seen version of the "What's New" dialog.
class GroundControlVersionStore {
  static const String _lastSeenVersionKey = 'ground_control_last_seen_version';
  static const String _cachedConfigKey = 'ground_control_cached_config_json';

  /// Saves the version that the user has already seen.
  static Future<void> saveLastSeenVersion(String version) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastSeenVersionKey, version);
  }

  /// Gets the last version the user has seen.
  static Future<String?> getLastSeenVersion() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastSeenVersionKey);
  }

  /// Caches the raw JSON config for offline fallback.
  static Future<void> cacheConfig(String jsonString) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cachedConfigKey, jsonString);
  }

  /// Retrieves the cached JSON config.
  static Future<String?> getCachedConfig() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_cachedConfigKey);
  }

  /// Clears the history (mainly for testing/debugging in the example app).
  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_lastSeenVersionKey);
  }
}
