## 0.1.0

* Initial release.
* `BankCardScanner.scanCard()` opens a full-screen native scanner and returns
  the recognized card number and expiry date, or `null` when cancelled.
* Android: on-device recognition with bundled TensorFlow Lite models
  (derived from Bouncer CardScan). Requires minSdk 24.
* iOS: on-device recognition with Apple's Vision framework (derived from
  yhkaplan/CreditCardScanner). Requires iOS 13.
* Customizable scanner UI texts via `scanCardText` and `positionCardText`.
