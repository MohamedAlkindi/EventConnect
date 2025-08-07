import 'dart:ui';

Locale? Function(Locale?, Iterable<Locale>)? localeResolutionCallbac =
    (locale, supportedLocales) {
  for (var supportedLocale in supportedLocales) {
    if (supportedLocale.languageCode == locale?.languageCode) {
      return supportedLocale;
    }
  }
  return supportedLocales.first;
};
