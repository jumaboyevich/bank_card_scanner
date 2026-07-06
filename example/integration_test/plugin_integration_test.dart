// This is a basic Flutter integration test.
//
// Since integration tests run in a full Flutter application, they can interact
// with the host side of a plugin implementation, unlike Dart unit tests.
//
// For more information about Flutter integration tests, please see
// https://flutter.dev/to/integration-testing

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:bank_card_scanner/bank_card_scanner.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('plugin can be instantiated', (WidgetTester tester) async {
    // Scanning itself requires a camera and user interaction, so the
    // integration test only verifies that the plugin API is wired up.
    final BankCardScanner plugin = BankCardScanner();
    expect(plugin, isNotNull);
  });
}
