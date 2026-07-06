import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'bank_card_scanner_method_channel.dart';
import 'src/bank_card_details.dart';

abstract class BankCardScannerPlatform extends PlatformInterface {
  /// Constructs a BankCardScannerPlatform.
  BankCardScannerPlatform() : super(token: _token);

  static final Object _token = Object();

  static BankCardScannerPlatform _instance = MethodChannelBankCardScanner();

  /// The default instance of [BankCardScannerPlatform] to use.
  ///
  /// Defaults to [MethodChannelBankCardScanner].
  static BankCardScannerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [BankCardScannerPlatform] when
  /// they register themselves.
  static set instance(BankCardScannerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Opens the native card scanner UI and returns the recognized card, or
  /// `null` if the user cancelled.
  Future<BankCardDetails?> scanCard({
    String? scanCardText,
    String? positionCardText,
  }) {
    throw UnimplementedError('scanCard() has not been implemented.');
  }
}
