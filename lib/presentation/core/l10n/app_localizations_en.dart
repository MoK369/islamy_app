// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get noInternetConnection => 'No Internet connection 😑';

  @override
  String get couldNotFindSource => 'Couldn\'t find the source 😱';

  @override
  String get badResponse => 'Bad response format 👎';

  @override
  String get connectionTimeout => 'Connection timeout with server ⌛';

  @override
  String get sendTimeout => 'Send timeout in connection with server ⏱';

  @override
  String get receiveTimeout => 'Receive timeout in connection with server ⏰';

  @override
  String get badCertificate =>
      'The certificate provided by the server is not valid 📑';

  @override
  String get requestCanceled => 'Request to server was cancelled ✖';

  @override
  String get somethingWentWrong => 'Something Went Wrong 🤔';

  @override
  String get islami => 'Islamic';

  @override
  String get quranLayout => 'Quran';

  @override
  String get search => 'Search';

  @override
  String get nameOfSura => 'Name of Sura';

  @override
  String get numberOfVerses => 'Number of Verses';

  @override
  String get alert => 'Alert!!';

  @override
  String get cancel => 'Cancel';

  @override
  String get ok => 'OK';

  @override
  String get hadeethLayout => 'Hadith';

  @override
  String get ahadeeth => 'Hadiths';

  @override
  String get settingsLayout => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get themeMode => 'Theme Mode';

  @override
  String get enableNavigationBar => 'Enable Navigation Bar';

  @override
  String get modes => 'Modes';

  @override
  String get lightTheme => 'Light Theme';

  @override
  String get darkTheme => 'Dark Theme';

  @override
  String get radioLayout => 'Radio';

  @override
  String get holyQuranRadio => 'Holy Quran Radio';

  @override
  String get sebhaLayout => 'Sebha';

  @override
  String get numberOfPraises => 'Number of Praises';

  @override
  String get pressAgain => 'Press Again to exit';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get updateAvailable => 'Update Available';

  @override
  String newVersionMessage(Object version) {
    return 'A new version $version is available.';
  }

  @override
  String get update => 'update';

  @override
  String get later => 'later';
}
