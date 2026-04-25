import 'package:flutter_test/flutter_test.dart';
import 'package:ground_control/src/services/ground_control_checker.dart';

void main() {
  group('GroundControlVersionComparator Tests', () {
    test('isGreater should compare correctly', () {
      expect(GroundControlVersionComparator.isGreater('2.0.0', '1.9.9'), true);
      expect(GroundControlVersionComparator.isGreater('1.10.0', '1.9.0'), true);
      expect(GroundControlVersionComparator.isGreater('1.2.3', '1.2.3'), false);
      expect(GroundControlVersionComparator.isGreater('1.2.2', '1.2.3'), false);
    });

    test('isLess should compare correctly', () {
      expect(GroundControlVersionComparator.isLess('1.0.0', '2.0.0'), true);
      expect(GroundControlVersionComparator.isLess('1.9.9', '1.10.0'), true);
      expect(GroundControlVersionComparator.isLess('2.0.0', '2.0.0'), false);
    });

    test('Should handle malformed strings gracefully', () {
      // Defaults to 0.0.0 for bad strings
      expect(GroundControlVersionComparator.isGreater('2.0', '1.0.0'), true);
      expect(GroundControlVersionComparator.isGreater('abc', '1.0.0'), false);
    });
  });
}
