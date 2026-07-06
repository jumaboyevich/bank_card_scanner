# bank_card_scanner

On-device bank card scanner for Flutter (Android & iOS). Opens a full-screen
native camera UI, recognizes the card number and expiry date, and returns them
to Dart — fully offline, no network calls, no card images leave the device.

| Platform | Engine | Minimum version |
| -------- | ------ | --------------- |
| Android  | Bundled TensorFlow Lite models (derived from [Bouncer CardScan](https://github.com/getbouncer/cardscan-android)) | API 24 (Android 7.0) |
| iOS      | Apple Vision framework OCR (derived from [CreditCardScanner](https://github.com/yhkaplan/credit-card-scanner)) | iOS 13 |

## Usage

```dart
import 'package:bank_card_scanner/bank_card_scanner.dart';

final scanner = BankCardScanner();

final card = await scanner.scanCard(
  // Optional UI texts, e.g. for localization:
  scanCardText: 'Scan your card',
  positionCardText: 'Position your card inside the frame so the number is visible.',
);

if (card != null) {
  print(card.cardNumber);          // e.g. 8600123412341234
  print(card.expiryMonth);         // e.g. 5, or null if not recognized
  print(card.expiryYear);          // e.g. 27, or null if not recognized
  print(card.formattedExpiryDate); // e.g. 05/27, or null
} else {
  // The user cancelled the scanner.
}
```

`scanCard` throws a `PlatformException` with one of these codes on failure:

| Code | Meaning |
| ---- | ------- |
| `PERMISSION_DENIED` | Camera access was denied. |
| `CAMERA_ERROR` | The camera could not be opened (Android). |
| `SCAN_ERROR` | An unrecoverable error occurred while scanning. |
| `ALREADY_ACTIVE` | A scan is already in progress. |
| `NO_ACTIVITY` | No foreground activity / view controller was available. |

## Setup

### Android

No configuration required. The plugin declares the `CAMERA` permission and the
scanner activity in its own manifest, and asks for the camera permission at
runtime. `minSdkVersion` must be at least 24.

### iOS

Add a camera usage description to `ios/Runner/Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>The camera is used to scan your bank card.</string>
```

The deployment target must be iOS 13.0 or later.

## Security notes

* All recognition happens on the device; the plugin makes no network requests.
* Only the card number and expiry date are returned. The cardholder name is
  not extracted, and no frames or images are stored.
* Handle the returned card data according to the PCI DSS requirements that
  apply to your application.

## Credits

* Android implementation derived from
  [Bouncer CardScan](https://github.com/getbouncer/cardscan-android) (MIT).
* iOS implementation derived from
  [yhkaplan/CreditCardScanner](https://github.com/yhkaplan/credit-card-scanner) (MIT).
