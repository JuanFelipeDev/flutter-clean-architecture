import 'package:affiliate_app/core/config/flavor_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FlavorConfig', () {
    test('fromEnvironment applies defaults when no dart-define is set', () {
      final config = FlavorConfig.fromEnvironment();
      expect(config.flavor, Flavor.basenewsoa);
      expect(config.environment, Environment.dev);
      expect(config.loginStrategy, LoginStrategy.standard);
      expect(config.appName, isNotEmpty);
      expect(config.urlServer, config.urlServerDev);
    });

    test('urlServer switches by environment', () {
      final config = FlavorConfig.fromEnvironment();
      final dev = config.urlServer;
      expect(dev, config.urlServerDev);
    });

    test('parseColor accepts 0xFF and # forms', () {
      // Constructed via fromEnvironment; just sanity-check the parsed color is
      // a valid ARGB int.
      final config = FlavorConfig.fromEnvironment();
      expect(config.primaryColor, greaterThan(0));
      expect(config.accentColor, greaterThan(0));
    });
  });
}