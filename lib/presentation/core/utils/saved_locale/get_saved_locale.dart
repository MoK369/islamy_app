import 'package:injectable/injectable.dart';
import 'package:islamy_app/presentation/core/utils/constants/locale_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class GetSavedLocale {
  @Named(LocaleConstants.getSavedLocale)
  @injectable
  String getSavedLocale(SharedPreferences sharedPreferences) {
    return sharedPreferences.getString(LocaleConstants.localeKey) ?? 'ar';
  }
}
