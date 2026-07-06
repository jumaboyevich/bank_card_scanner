import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'bank_card_scanner_platform_interface.dart';
import 'src/bank_card_details.dart';

/// An implementation of [BankCardScannerPlatform] that uses method channels.
class MethodChannelBankCardScanner extends BankCardScannerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('bank_card_scanner');

  @override
  Future<BankCardDetails?> scanCard({
    String? scanCardText,
    String? positionCardText,
  }) async {
    final result = await methodChannel.invokeMapMethod<String, dynamic>(
      'scanCard',
      <String, dynamic>{
        'scanCardText': ?scanCardText,
        'positionCardText': ?positionCardText,
      },
    );
    if (result == null) return null;
    return BankCardDetails.fromMap(result);
  }
}
