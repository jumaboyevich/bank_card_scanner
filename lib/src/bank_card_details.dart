import 'package:flutter/foundation.dart';

/// The result of a successful bank card scan.
@immutable
class BankCardDetails {
  const BankCardDetails({
    required this.cardNumber,
    this.expiryMonth,
    this.expiryYear,
  });

  /// Creates a [BankCardDetails] from the map returned by the platform side.
  factory BankCardDetails.fromMap(Map<String, dynamic> map) {
    return BankCardDetails(
      cardNumber: map['cardNumber'] as String,
      expiryMonth: map['expiryMonth'] as int?,
      expiryYear: map['expiryYear'] as int?,
    );
  }

  /// The recognized card number, digits only (e.g. `8600123412341234`).
  final String cardNumber;

  /// The expiry month (1-12), or `null` if it was not recognized.
  final int? expiryMonth;

  /// The expiry year as a two-digit value (e.g. `27`), or `null` if it was
  /// not recognized.
  final int? expiryYear;

  /// Whether both the expiry month and year were recognized.
  bool get hasExpiryDate => expiryMonth != null && expiryYear != null;

  /// The expiry date formatted as `MM/YY`, or `null` if it was not recognized.
  String? get formattedExpiryDate {
    if (!hasExpiryDate) return null;
    final month = expiryMonth!.toString().padLeft(2, '0');
    final year = (expiryYear! % 100).toString().padLeft(2, '0');
    return '$month/$year';
  }

  @override
  bool operator ==(Object other) =>
      other is BankCardDetails &&
      other.cardNumber == cardNumber &&
      other.expiryMonth == expiryMonth &&
      other.expiryYear == expiryYear;

  @override
  int get hashCode => Object.hash(cardNumber, expiryMonth, expiryYear);

  @override
  String toString() => 'BankCardDetails(cardNumber: $cardNumber, '
      'expiryMonth: $expiryMonth, expiryYear: $expiryYear)';
}
