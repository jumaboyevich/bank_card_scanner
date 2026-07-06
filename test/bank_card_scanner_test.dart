import 'package:flutter_test/flutter_test.dart';
import 'package:bank_card_scanner/bank_card_scanner.dart';
import 'package:bank_card_scanner/bank_card_scanner_platform_interface.dart';
import 'package:bank_card_scanner/bank_card_scanner_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockBankCardScannerPlatform
    with MockPlatformInterfaceMixin
    implements BankCardScannerPlatform {
  String? lastScanCardText;

  @override
  Future<BankCardDetails?> scanCard({
    String? scanCardText,
    String? positionCardText,
  }) {
    lastScanCardText = scanCardText;
    return Future.value(
      const BankCardDetails(
        cardNumber: '8600123412341234',
        expiryMonth: 5,
        expiryYear: 27,
      ),
    );
  }
}

void main() {
  final BankCardScannerPlatform initialPlatform =
      BankCardScannerPlatform.instance;

  test('$MethodChannelBankCardScanner is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelBankCardScanner>());
  });

  test('scanCard forwards arguments and returns card details', () async {
    BankCardScanner bankCardScannerPlugin = BankCardScanner();
    MockBankCardScannerPlatform fakePlatform = MockBankCardScannerPlatform();
    BankCardScannerPlatform.instance = fakePlatform;

    final card = await bankCardScannerPlugin.scanCard(scanCardText: 'Scan');
    expect(fakePlatform.lastScanCardText, 'Scan');
    expect(card!.cardNumber, '8600123412341234');
    expect(card.formattedExpiryDate, '05/27');
  });

  group('BankCardDetails', () {
    test('fromMap parses platform payload', () {
      final card = BankCardDetails.fromMap(<String, dynamic>{
        'cardNumber': '8600123412341234',
        'expiryMonth': 5,
        'expiryYear': 27,
      });
      expect(card.cardNumber, '8600123412341234');
      expect(card.expiryMonth, 5);
      expect(card.expiryYear, 27);
      expect(card.hasExpiryDate, isTrue);
      expect(card.formattedExpiryDate, '05/27');
    });

    test('fromMap tolerates missing expiry', () {
      final card = BankCardDetails.fromMap(<String, dynamic>{
        'cardNumber': '8600123412341234',
      });
      expect(card.hasExpiryDate, isFalse);
      expect(card.formattedExpiryDate, isNull);
    });

    test('formattedExpiryDate handles four-digit years', () {
      const card = BankCardDetails(
        cardNumber: '8600123412341234',
        expiryMonth: 12,
        expiryYear: 2027,
      );
      expect(card.formattedExpiryDate, '12/27');
    });
  });
}
