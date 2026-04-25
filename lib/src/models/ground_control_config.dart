/// Model representing the remote JSON configuration for GroundControl.
class GroundControlConfig {
  /// Configuration for maintenance mode.
  final MaintenanceConfig maintenance;

  /// Configuration for force update logic.
  final ForceUpdateConfig forceUpdate;

  /// Configuration for the "What's New" dialog.
  final WhatsNewConfig whatsNew;

  /// Creates a [GroundControlConfig] instance.
  const GroundControlConfig({
    required this.maintenance,
    required this.forceUpdate,
    required this.whatsNew,
  });

  /// Creates a [GroundControlConfig] from a JSON map.
  factory GroundControlConfig.fromJson(Map<String, dynamic> json) {
    return GroundControlConfig(
      maintenance: MaintenanceConfig.fromJson(
        json['maintenance'] as Map<String, dynamic>? ?? {},
      ),
      forceUpdate: ForceUpdateConfig.fromJson(
        json['force_update'] as Map<String, dynamic>? ?? {},
      ),
      whatsNew: WhatsNewConfig.fromJson(
        json['whats_new'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  /// Converts the config to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'maintenance': maintenance.toJson(),
      'force_update': forceUpdate.toJson(),
      'whats_new': whatsNew.toJson(),
    };
  }
}

/// Configuration for the maintenance screen.
class MaintenanceConfig {
  /// Whether maintenance mode is currently enabled.
  final bool enabled;

  /// The title to display on the maintenance screen.
  final String title;

  /// The message to display on the maintenance screen.
  final String message;

  /// Optional estimated time when maintenance will end.
  final DateTime? estimatedEnd;

  const MaintenanceConfig({
    required this.enabled,
    required this.title,
    required this.message,
    this.estimatedEnd,
  });

  factory MaintenanceConfig.fromJson(Map<String, dynamic> json) {
    return MaintenanceConfig(
      enabled: json['enabled'] as bool? ?? false,
      title: json['title'] as String? ?? 'Maintenance',
      message: json['message'] as String? ?? 'We are currently performing maintenance.',
      estimatedEnd: json['estimated_end'] != null
          ? DateTime.tryParse(json['estimated_end'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enabled': enabled,
      'title': title,
      'message': message,
      'estimated_end': estimatedEnd?.toIso8601String(),
    };
  }
}

/// Configuration for the force update dialog.
class ForceUpdateConfig {
  /// Whether force update logic is enabled.
  final bool enabled;

  /// The minimum version required to use the app.
  final String minVersion;

  /// The title for the update dialog.
  final String title;

  /// The message for the update dialog.
  final String message;

  /// URL for the Google Play Store.
  final String storeUrlAndroid;

  /// URL for the Apple App Store.
  final String storeUrlIos;

  const ForceUpdateConfig({
    required this.enabled,
    required this.minVersion,
    required this.title,
    required this.message,
    required this.storeUrlAndroid,
    required this.storeUrlIos,
  });

  factory ForceUpdateConfig.fromJson(Map<String, dynamic> json) {
    return ForceUpdateConfig(
      enabled: json['enabled'] as bool? ?? false,
      minVersion: json['min_version'] as String? ?? '1.0.0',
      title: json['title'] as String? ?? 'Update Required',
      message: json['message'] as String? ?? 'Please update to continue.',
      storeUrlAndroid: json['store_url_android'] as String? ?? '',
      storeUrlIos: json['store_url_ios'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enabled': enabled,
      'min_version': minVersion,
      'title': title,
      'message': message,
      'store_url_android': storeUrlAndroid,
      'store_url_ios': storeUrlIos,
    };
  }
}

/// Configuration for the "What's New" feature.
class WhatsNewConfig {
  /// Whether the what's new feature is enabled.
  final bool enabled;

  /// The version string associated with these release notes.
  final String version;

  /// The title for the what's new dialog.
  final String title;

  /// The list of items to display.
  final List<WhatsNewItem> items;

  const WhatsNewConfig({
    required this.enabled,
    required this.version,
    required this.title,
    required this.items,
  });

  factory WhatsNewConfig.fromJson(Map<String, dynamic> json) {
    return WhatsNewConfig(
      enabled: json['enabled'] as bool? ?? false,
      version: json['version'] as String? ?? '1.0.0',
      title: json['title'] as String? ?? "What's New",
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => WhatsNewItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enabled': enabled,
      'version': version,
      'title': title,
      'items': items.map((e) => e.toJson()).toList(),
    };
  }
}

/// A single item in the "What's New" list.
class WhatsNewItem {
  /// Emoji icon for the feature.
  final String emoji;

  /// Title of the feature/change.
  final String title;

  /// Detailed description of the change.
  final String description;

  const WhatsNewItem({
    required this.emoji,
    required this.title,
    required this.description,
  });

  factory WhatsNewItem.fromJson(Map<String, dynamic> json) {
    return WhatsNewItem(
      emoji: json['emoji'] as String? ?? '✨',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'emoji': emoji,
      'title': title,
      'description': description,
    };
  }
}
