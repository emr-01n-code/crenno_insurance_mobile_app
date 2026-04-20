import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await initializeDateFormatting('tr_TR');
  await initializeDateFormatting('en_US');

  final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;
  final initialLocale = systemLocale.languageCode == 'tr'
      ? const Locale('tr')
      : const Locale('en');

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('tr')],
      path: 'assets/languages',
      fallbackLocale: const Locale('en'),
      startLocale: initialLocale,
      child: const ProviderScope(
        child: InsuranceApp(),
      ),
    ),
  );
}
