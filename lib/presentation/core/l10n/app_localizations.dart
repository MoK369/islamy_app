import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @noInternetConnection.
  ///
  /// In ar, this message translates to:
  /// **'لا يوجد اتصال بالإنترنت 😑'**
  String get noInternetConnection;

  /// No description provided for @couldNotFindSource.
  ///
  /// In ar, this message translates to:
  /// **'تعذر العثور على المصدر 😱'**
  String get couldNotFindSource;

  /// No description provided for @badResponse.
  ///
  /// In ar, this message translates to:
  /// **'تنسيق الاستجابة غير صالح 👎'**
  String get badResponse;

  /// No description provided for @connectionTimeout.
  ///
  /// In ar, this message translates to:
  /// **'انتهت مهلة الاتصال بالخادم ⌛'**
  String get connectionTimeout;

  /// No description provided for @sendTimeout.
  ///
  /// In ar, this message translates to:
  /// **'انتهت مهلة الإرسال في الاتصال بالخادم ⏱'**
  String get sendTimeout;

  /// No description provided for @receiveTimeout.
  ///
  /// In ar, this message translates to:
  /// **'انتهت مهلة الاستلام في الاتصال بالخادم ⏰'**
  String get receiveTimeout;

  /// No description provided for @badCertificate.
  ///
  /// In ar, this message translates to:
  /// **'شهادة الخادم غير صالحة 📑'**
  String get badCertificate;

  /// No description provided for @requestCanceled.
  ///
  /// In ar, this message translates to:
  /// **'تم إلغاء الطلب إلى الخادم ✖'**
  String get requestCanceled;

  /// No description provided for @somethingWentWrong.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ ما 🤔'**
  String get somethingWentWrong;

  /// No description provided for @islami.
  ///
  /// In ar, this message translates to:
  /// **'إسلامي'**
  String get islami;

  /// No description provided for @quranLayout.
  ///
  /// In ar, this message translates to:
  /// **'القرآن'**
  String get quranLayout;

  /// No description provided for @search.
  ///
  /// In ar, this message translates to:
  /// **'بحث'**
  String get search;

  /// No description provided for @nameOfSura.
  ///
  /// In ar, this message translates to:
  /// **'اسم السورة'**
  String get nameOfSura;

  /// No description provided for @numberOfVerses.
  ///
  /// In ar, this message translates to:
  /// **'عدد الآيات'**
  String get numberOfVerses;

  /// No description provided for @alert.
  ///
  /// In ar, this message translates to:
  /// **'تنبيه!!'**
  String get alert;

  /// No description provided for @cancel.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء'**
  String get cancel;

  /// No description provided for @ok.
  ///
  /// In ar, this message translates to:
  /// **'موافق'**
  String get ok;

  /// No description provided for @hadeethLayout.
  ///
  /// In ar, this message translates to:
  /// **'الحديث'**
  String get hadeethLayout;

  /// No description provided for @ahadeeth.
  ///
  /// In ar, this message translates to:
  /// **'أحاديث'**
  String get ahadeeth;

  /// No description provided for @settingsLayout.
  ///
  /// In ar, this message translates to:
  /// **'الإعدادات'**
  String get settingsLayout;

  /// No description provided for @language.
  ///
  /// In ar, this message translates to:
  /// **'اللغة'**
  String get language;

  /// No description provided for @themeMode.
  ///
  /// In ar, this message translates to:
  /// **'وضع السمة'**
  String get themeMode;

  /// No description provided for @enableNavigationBar.
  ///
  /// In ar, this message translates to:
  /// **'تمكين شريط التنقل'**
  String get enableNavigationBar;

  /// No description provided for @modes.
  ///
  /// In ar, this message translates to:
  /// **'الأوضاع'**
  String get modes;

  /// No description provided for @lightTheme.
  ///
  /// In ar, this message translates to:
  /// **'الوضع الفاتح'**
  String get lightTheme;

  /// No description provided for @darkTheme.
  ///
  /// In ar, this message translates to:
  /// **'الوضع الداكن'**
  String get darkTheme;

  /// No description provided for @radioLayout.
  ///
  /// In ar, this message translates to:
  /// **'الراديو'**
  String get radioLayout;

  /// No description provided for @holyQuranRadio.
  ///
  /// In ar, this message translates to:
  /// **'راديو القرآن الكريم'**
  String get holyQuranRadio;

  /// No description provided for @sebhaLayout.
  ///
  /// In ar, this message translates to:
  /// **'سبحة'**
  String get sebhaLayout;

  /// No description provided for @numberOfPraises.
  ///
  /// In ar, this message translates to:
  /// **'عدد التسبيحات'**
  String get numberOfPraises;

  /// No description provided for @pressAgain.
  ///
  /// In ar, this message translates to:
  /// **'اضغط مرة أخرى للخروج'**
  String get pressAgain;

  /// No description provided for @tryAgain.
  ///
  /// In ar, this message translates to:
  /// **'حاول مجدداً'**
  String get tryAgain;

  /// No description provided for @updateAvailable.
  ///
  /// In ar, this message translates to:
  /// **'تحديث متوفر'**
  String get updateAvailable;

  /// No description provided for @newVersionMessage.
  ///
  /// In ar, this message translates to:
  /// **'إصدار جديد {version} متاح.'**
  String newVersionMessage(Object version);

  /// No description provided for @update.
  ///
  /// In ar, this message translates to:
  /// **'تحديث'**
  String get update;

  /// No description provided for @later.
  ///
  /// In ar, this message translates to:
  /// **'لاحقًا'**
  String get later;

  /// No description provided for @errorInitializingAudioSources.
  ///
  /// In ar, this message translates to:
  /// **'خطأ في تهيئة مصادر الصوت: '**
  String get errorInitializingAudioSources;

  /// No description provided for @errorReplayingAudio.
  ///
  /// In ar, this message translates to:
  /// **'خطأ في إعادة تشغيل الصوت: '**
  String get errorReplayingAudio;

  /// No description provided for @audioSessionNotActive.
  ///
  /// In ar, this message translates to:
  /// **'جلسة الصوت غير مفعّلة'**
  String get audioSessionNotActive;

  /// No description provided for @errorMovingToNextChannel.
  ///
  /// In ar, this message translates to:
  /// **'خطأ في الانتقال إلى القناة التالية: '**
  String get errorMovingToNextChannel;

  /// No description provided for @errorMovingToPreviousChannel.
  ///
  /// In ar, this message translates to:
  /// **'خطأ في الانتقال إلى القناة السابقة: '**
  String get errorMovingToPreviousChannel;

  /// No description provided for @errorOccurred.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ. يرجى المحاولة مرة أخرى لاحقًا'**
  String get errorOccurred;

  /// No description provided for @errorLoadingSavedData.
  ///
  /// In ar, this message translates to:
  /// **'خطأ في تحميل البيانات المحفوظة'**
  String get errorLoadingSavedData;

  /// No description provided for @errorSavingFontSize.
  ///
  /// In ar, this message translates to:
  /// **'خطأ في حفظ قيمة حجم الخط'**
  String get errorSavingFontSize;

  /// No description provided for @errorSavingNewMarkedVerse.
  ///
  /// In ar, this message translates to:
  /// **'خطأ في حفظ الآية المحددة الجديدة'**
  String get errorSavingNewMarkedVerse;

  /// No description provided for @errorSavingNewMarkedPDFPage.
  ///
  /// In ar, this message translates to:
  /// **'خطأ في حفظ صفحة PDF المحددة الجديدة'**
  String get errorSavingNewMarkedPDFPage;

  /// No description provided for @errorChangingAppBarVisibility.
  ///
  /// In ar, this message translates to:
  /// **'خطأ في تغيير ظهور شريط التطبيق'**
  String get errorChangingAppBarVisibility;

  /// No description provided for @errorShowingAlertVersesMarkingDialog.
  ///
  /// In ar, this message translates to:
  /// **'خطأ في عرض نافذة تنبيه تحديد الآيات'**
  String get errorShowingAlertVersesMarkingDialog;

  /// No description provided for @errorShowingAlertPDFPageMarkingDialog.
  ///
  /// In ar, this message translates to:
  /// **'خطأ في عرض نافذة تنبيه تحديد صفحة PDF'**
  String get errorShowingAlertPDFPageMarkingDialog;

  /// No description provided for @errorPlayingAudio.
  ///
  /// In ar, this message translates to:
  /// **'خطأ في تشغيل الصوت'**
  String get errorPlayingAudio;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
