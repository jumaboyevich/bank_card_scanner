import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bank_card_scanner/bank_card_scanner.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: ScanPage());
  }
}

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final _scanner = BankCardScanner();

  BankCardDetails? _card;
  String? _error;

  Future<void> _scan() async {
    try {
      final card = await _scanner.scanCard(
        scanCardText: 'Scan your card',
        positionCardText:
            'Position your card inside the frame so the number is visible.',
      );
      setState(() {
        _card = card;
        _error = card == null ? 'Cancelled' : null;
      });
    } on PlatformException catch (e) {
      setState(() {
        _card = null;
        _error = '${e.code}: ${e.message}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final card = _card;
    return Scaffold(
      appBar: AppBar(title: const Text('bank_card_scanner example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (card != null) ...[
              Text(
                card.cardNumber,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text('Expires: ${card.formattedExpiryDate ?? 'not recognized'}'),
            ] else
              Text(_error ?? 'No card scanned yet'),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _scan,
              icon: const Icon(Icons.credit_card),
              label: const Text('Scan card'),
            ),
          ],
        ),
      ),
    );
  }
}
