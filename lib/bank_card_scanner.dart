/// On-device bank card scanner for Android and iOS.
///
/// Recognizes the card number and expiry date with the device camera, fully
/// offline: TensorFlow Lite models on Android and Apple's Vision framework
/// on iOS.
library;

import 'bank_card_scanner_platform_interface.dart';
import 'src/bank_card_details.dart';

export 'src/bank_card_details.dart';

class BankCardScanner {
  /// Opens the full-screen native card scanner and completes with the
  /// recognized card details.
  ///
  /// Completes with `null` when the user cancels the scanner.
  ///
  /// Throws a `PlatformException` with one of the following codes when
  /// something goes wrong:
  ///
  /// * `PERMISSION_DENIED` – camera access was denied.
  /// * `CAMERA_ERROR` – the camera could not be opened (Android).
  /// * `SCAN_ERROR` – an unrecoverable error occurred while scanning.
  /// * `ALREADY_ACTIVE` – a scan is already in progress.
  /// * `NO_ACTIVITY` – no foreground activity/view controller to attach to.
  ///
  /// [scanCardText] and [positionCardText] override the texts shown in the
  /// scanner UI (e.g. for localization).
  Future<BankCardDetails?> scanCard({
    String? scanCardText,
    String? positionCardText,
  }) {
    return BankCardScannerPlatform.instance.scanCard(
      scanCardText: scanCardText,
      positionCardText: positionCardText,
    );
  }
}
