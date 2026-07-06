import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bank_card_scanner/bank_card_scanner.dart';
import 'package:bank_card_scanner/bank_card_scanner_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelBankCardScanner platform = MethodChannelBankCardScanner();
  const MethodChannel channel = MethodChannel('bank_card_scanner');

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('scanCard returns parsed card details', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          expect(methodCall.method, 'scanCard');
          expect(methodCall.arguments, <String, dynamic>{
            'scanCardText': 'Scan card',
          });
          return <String, dynamic>{
            'cardNumber': '8600123412341234',
            'expiryMonth': 5,
            'expiryYear': 27,
          };
        });

    final card = await platform.scanCard(scanCardText: 'Scan card');
    expect(
      card,
      const BankCardDetails(
        cardNumber: '8600123412341234',
        expiryMonth: 5,
        expiryYear: 27,
      ),
    );
  });

  test('scanCard returns null when the user cancels', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          return null;
        });

    expect(await platform.scanCard(), isNull);
  });
}
