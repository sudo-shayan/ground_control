import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ground_control/src/services/ground_control_version_store.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GroundControlVersionStore Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('Should save and retrieve last seen version', () async {
      await GroundControlVersionStore.saveLastSeenVersion('1.2.3');
      final version = await GroundControlVersionStore.getLastSeenVersion();
      expect(version, '1.2.3');
    });

    test('Should cache and retrieve config JSON', () async {
      const json = '{"key": "value"}';
      await GroundControlVersionStore.cacheConfig(json);
      final retrieved = await GroundControlVersionStore.getCachedConfig();
      expect(retrieved, json);
    });

    test('clearHistory should remove last seen version', () async {
      await GroundControlVersionStore.saveLastSeenVersion('1.0.0');
      await GroundControlVersionStore.clearHistory();
      final version = await GroundControlVersionStore.getLastSeenVersion();
      expect(version, isNull);
    });
  });
}
