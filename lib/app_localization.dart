import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class AppLocalizations {
  Locale? locale;
  List<Locale> locales;
  List<String> supportedLocalCodes;

//main al beni al
  AppLocalizations(
      {this.locale, required this.locales, required this.supportedLocalCodes});

//localization işlemi mainde kullanılıyor
   localizationDelegates() {
    return [
      AppLocalizations(supportedLocalCodes: supportedLocalCodes, locales: locales).delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ];
  }

  //supported locales
  supportedLocales() {
    return locales;
  }

  //inherited callback functiıons
  static localeResolutionCallback(locale, supportedLocales) {
    // Check if the current device locale is supported
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale!.languageCode &&
          supportedLocale.countryCode == locale.countryCode) {
        return supportedLocale;
      }
    }
    // If the locale of the device is not supported, use the first one
    // from the list (English, in this case).
    return supportedLocales.first;
  }

  // Helper method to keep the code in the widgets concise
  // Localizations are accessed using an InheritedWidget "of" syntax
  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

    LocalizationsDelegate<AppLocalizations> delegate() =>
      _AppLocalizationsDelegate(supportedLocalCodes,locales);

  Map<String, String>? _localizedStrings;

  Future<bool> load() async {
    // Load the language JSON file from the "lang" folder
    String jsonString =
        await rootBundle.loadString('lang/${locale!.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  // This method will be called from every widget which needs a localized text
  String? translate(String key) {
    return _localizedStrings![key];
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  // This delegate instance will never change (it doesn't even have fields!)
  // It can provide a constant constructor.
  final List<String> supportedLocales;
  final List<Locale> locals;
  const _AppLocalizationsDelegate(this.supportedLocales, this.locals);

  @override
  bool isSupported(Locale locale) {
    // Include all of your supported language codes here
    return supportedLocales.contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    // AppLocalizations class is where the JSON loading actually runs
    AppLocalizations localizations = AppLocalizations(locales: locals, supportedLocalCodes: supportedLocales);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
