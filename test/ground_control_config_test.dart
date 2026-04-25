import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:ground_control/src/models/ground_control_config.dart';

void main() {
  group('GroundControlConfig Parser Tests', () {
    test('Should parse full valid JSON correctly', () {
      const jsonStr = '''
      {
        "maintenance": {
          "enabled": true,
          "title": "M_Title",
          "message": "M_Msg",
          "estimated_end": "2025-12-01T18:00:00Z"
        },
        "force_update": {
          "enabled": true,
          "min_version": "2.1.0",
          "title": "F_Title",
          "message": "F_Msg",
          "store_url_android": "url_a",
          "store_url_ios": "url_i"
        },
        "whats_new": {
          "enabled": true,
          "version": "3.0.0",
          "title": "W_Title",
          "items": [
            { "emoji": "🚀", "title": "Item1", "description": "Desc1" }
          ]
        }
      }
      ''';

      final config = GroundControlConfig.fromJson(json.decode(jsonStr));

      expect(config.maintenance.enabled, true);
      expect(config.maintenance.title, 'M_Title');
      expect(config.maintenance.estimatedEnd, isNotNull);
      
      expect(config.forceUpdate.minVersion, '2.1.0');
      expect(config.forceUpdate.storeUrlAndroid, 'url_a');

      expect(config.whatsNew.version, '3.0.0');
      expect(config.whatsNew.items.length, 1);
      expect(config.whatsNew.items.first.emoji, '🚀');
    });

    test('Should handle missing fields with defaults', () {
      final config = GroundControlConfig.fromJson({});
      
      expect(config.maintenance.enabled, false);
      expect(config.forceUpdate.enabled, false);
      expect(config.whatsNew.enabled, false);
      expect(config.whatsNew.items, isEmpty);
    });
  });
}
