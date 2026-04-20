import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static final DateFormat _iso = DateFormat('yyyy-MM-dd');

  static String display(DateTime date, [String? locale]) {
    final intlLocale = _normalize(locale);
    return DateFormat('dd MMM yyyy', intlLocale).format(date);
  }

  static String iso(DateTime date) => _iso.format(date);

  static String _normalize(String? locale) {
    if (locale == null) return 'tr_TR';
    final lower = locale.toLowerCase();
    if (lower.startsWith('tr')) return 'tr_TR';
    if (lower.startsWith('en')) return 'en_US';
    return locale;
  }
}
