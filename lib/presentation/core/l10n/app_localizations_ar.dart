// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get noInternetConnection => 'لا يوجد اتصال بالإنترنت 😑';

  @override
  String get couldNotFindSource => 'تعذر العثور على المصدر 😱';

  @override
  String get badResponse => 'تنسيق الاستجابة غير صالح 👎';

  @override
  String get connectionTimeout => 'انتهت مهلة الاتصال بالخادم ⌛';

  @override
  String get sendTimeout => 'انتهت مهلة الإرسال في الاتصال بالخادم ⏱';

  @override
  String get receiveTimeout => 'انتهت مهلة الاستلام في الاتصال بالخادم ⏰';

  @override
  String get badCertificate => 'شهادة الخادم غير صالحة 📑';

  @override
  String get requestCanceled => 'تم إلغاء الطلب إلى الخادم ✖';

  @override
  String get somethingWentWrong => 'حدث خطأ ما 🤔';

  @override
  String get islami => 'إسلامي';

  @override
  String get quranLayout => 'القرآن';

  @override
  String get search => 'بحث';

  @override
  String get nameOfSura => 'اسم السورة';

  @override
  String get numberOfVerses => 'عدد الآيات';

  @override
  String get alert => 'تنبيه!!';

  @override
  String get cancel => 'إلغاء';

  @override
  String get ok => 'موافق';

  @override
  String get hadeethLayout => 'الحديث';

  @override
  String get ahadeeth => 'أحاديث';

  @override
  String get settingsLayout => 'الإعدادات';

  @override
  String get language => 'اللغة';

  @override
  String get themeMode => 'وضع السمة';

  @override
  String get enableNavigationBar => 'تمكين شريط التنقل';

  @override
  String get modes => 'الأوضاع';

  @override
  String get lightTheme => 'الوضع الفاتح';

  @override
  String get darkTheme => 'الوضع الداكن';

  @override
  String get radioLayout => 'الراديو';

  @override
  String get holyQuranRadio => 'راديو القرآن الكريم';

  @override
  String get sebhaLayout => 'سبحة';

  @override
  String get numberOfPraises => 'عدد التسبيحات';

  @override
  String get pressAgain => 'اضغط مرة أخرى للخروج';

  @override
  String get tryAgain => 'حاول مجدداً';

  @override
  String get updateAvailable => 'تحديث متوفر';

  @override
  String newVersionMessage(Object version) {
    return 'إصدار جديد $version متاح.';
  }

  @override
  String get update => 'تحديث';

  @override
  String get later => 'لاحقًا';

  @override
  String get errorInitializingAudioSources => 'خطأ في تهيئة مصادر الصوت: ';

  @override
  String get errorReplayingAudio => 'خطأ في إعادة تشغيل الصوت: ';

  @override
  String get audioSessionNotActive => 'جلسة الصوت غير مفعّلة';

  @override
  String get errorMovingToNextChannel => 'خطأ في الانتقال إلى القناة التالية: ';

  @override
  String get errorMovingToPreviousChannel =>
      'خطأ في الانتقال إلى القناة السابقة: ';

  @override
  String get errorOccurred => 'حدث خطأ. يرجى المحاولة مرة أخرى لاحقًا';

  @override
  String get errorLoadingSavedData => 'خطأ في تحميل البيانات المحفوظة';

  @override
  String get errorSavingFontSize => 'خطأ في حفظ قيمة حجم الخط';

  @override
  String get errorSavingNewMarkedVerse => 'خطأ في حفظ الآية المحددة الجديدة';

  @override
  String get errorSavingNewMarkedPDFPage =>
      'خطأ في حفظ صفحة PDF المحددة الجديدة';

  @override
  String get errorChangingAppBarVisibility => 'خطأ في تغيير ظهور شريط التطبيق';

  @override
  String get errorShowingAlertVersesMarkingDialog =>
      'خطأ في عرض نافذة تنبيه تحديد الآيات';

  @override
  String get errorShowingAlertPDFPageMarkingDialog =>
      'خطأ في عرض نافذة تنبيه تحديد صفحة PDF';

  @override
  String get errorPlayingAudio => 'خطأ في تشغيل الصوت';
}
