import 'package:intl/intl.dart';

class CurrencyFormatter {
  CurrencyFormatter._();

  static String format(num amount, String currencyCode, [String? locale]) {
    final symbol = switch (currencyCode.toUpperCase()) {
      'TRY' => '₺',
      'USD' => r'$',
      'EUR' => '€',
      _ => currencyCode,
    };
    final fmt = NumberFormat.currency(
      locale: _normalize(locale),
      symbol: symbol,
      decimalDigits: 0,
    );
    return fmt.format(amount);
  }

  static String _normalize(String? locale) {
    if (locale == null) return 'tr_TR';
    final lower = locale.toLowerCase();
    if (lower.startsWith('tr')) return 'tr_TR';
    if (lower.startsWith('en')) return 'en_US';
    return locale;
  }
}
