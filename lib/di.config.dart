// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;
import 'package:stash/stash_api.dart' as _i265;

import 'data/data_sources/quran_radio_channnels_data_sources/quran_radio_channels_remote_data_source.dart'
    as _i873;
import 'data/data_sources_imp/quran_radio_channnels_remote_data_source_imp.dart'
    as _i936;
import 'data/repositories_imp/app_version_check_repo_imp.dart' as _i829;
import 'data/repositories_imp/quran_radio_channels_repository_imp.dart'
    as _i1060;
import 'data/services/apis/api_manager.dart' as _i265;
import 'domain/repositories/app_version_check/app_version_check_repo.dart'
    as _i347;
import 'domain/repositories/quran_radio_channels/quran_radio_channels_repository.dart'
    as _i602;
import 'presentation/core/ads/start_io_ad_provider.dart' as _i680;
import 'presentation/core/app_version_checker/app_version_checker.dart'
    as _i680;
import 'presentation/core/l10n/app_localizations.dart' as _i632;
import 'presentation/core/providers/locale_provider.dart' as _i125;
import 'presentation/core/providers/theme_provider.dart' as _i797;
import 'presentation/core/utils/app_localizations/app_localizations_provider.dart'
    as _i211;
import 'presentation/core/utils/saved_locale/get_saved_locale.dart' as _i472;
import 'presentation/core/utils/shared_preferences/shared_preferences_provider.dart'
    as _i301;
import 'presentation/core/utils/text_file_caching/text_file_caching.dart'
    as _i163;
import 'presentation/modules/mainScreen/layouts/hadeeth_layout/view_models/hadeeth_layout_view_model.dart'
    as _i468;
import 'presentation/modules/mainScreen/layouts/quran_layout/surah_screen/pages/text_page/view_model/surah_text_page_view_model.dart'
    as _i572;
import 'presentation/modules/mainScreen/layouts/quran_layout/surah_screen/provider/surah_screen_provider.dart'
    as _i70;
import 'presentation/modules/mainScreen/layouts/radio_layout/manager/radio_view_model.dart'
    as _i647;
import 'presentation/modules/mainScreen/provider/main_screen_provider.dart'
    as _i545;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final textFileCaching = _$TextFileCaching();
    final sharedPreferencesProvider = _$SharedPreferencesProvider();
    final getSavedLocale = _$GetSavedLocale();
    final appLocalizationsProvider = _$AppLocalizationsProvider();
    await gh.factoryAsync<_i265.Cache<String>>(
      () => textFileCaching.createFileCache(),
      preResolve: true,
    );
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => sharedPreferencesProvider.provide(),
      preResolve: true,
    );
    gh.factory<_i680.StartIoAdProvider>(() => _i680.StartIoAdProvider());
    gh.singleton<_i265.ApiManager>(() => _i265.ApiManager());
    gh.factory<_i797.ThemeProvider>(
        () => _i797.ThemeProvider(gh<_i460.SharedPreferences>()));
    gh.factory<_i545.MainScreenProvider>(
        () => _i545.MainScreenProvider(gh<_i460.SharedPreferences>()));
    gh.factory<String>(
      () => getSavedLocale.getSavedLocale(gh<_i460.SharedPreferences>()),
      instanceName: 'getSavedLocale',
    );
    gh.factory<_i873.QuranRadioChannelsRemoteDataSource>(() =>
        _i936.QuranRadioChannelsRemoteDataSourceImp(gh<_i265.ApiManager>()));
    gh.factory<_i347.AppVersionCheckRepo>(
        () => _i829.AppVersionCheckRepoImp(gh<_i265.ApiManager>()));
    gh.factory<_i468.HadeethLayoutViewModel>(
        () => _i468.HadeethLayoutViewModel(gh<_i265.Cache<String>>()));
    gh.factory<_i572.SurahTextPageViewModel>(
        () => _i572.SurahTextPageViewModel(gh<_i265.Cache<String>>()));
    gh.factory<_i125.LocaleProvider>(() => _i125.LocaleProvider(
          gh<_i460.SharedPreferences>(),
          gh<String>(instanceName: 'getSavedLocale'),
        ));
    gh.factory<_i680.AppVersionCheckerViewModel>(() =>
        _i680.AppVersionCheckerViewModel(gh<_i347.AppVersionCheckRepo>()));
    gh.factory<_i602.QuranRadioChannelsRepository>(() =>
        _i1060.QuranRadioChannelsRepositoryImp(
            gh<_i873.QuranRadioChannelsRemoteDataSource>()));
    await gh.factoryAsync<_i632.AppLocalizations>(
      () => appLocalizationsProvider
          .provide(gh<String>(instanceName: 'getSavedLocale')),
      preResolve: true,
    );
    gh.singleton<_i647.RadioViewModel>(
        () => _i647.RadioViewModel(gh<_i602.QuranRadioChannelsRepository>()));
    gh.factory<_i70.SurahScreenProvider>(() => _i70.SurahScreenProvider(
          gh<_i460.SharedPreferences>(),
          gh<_i125.LocaleProvider>(),
        ));
    return this;
  }
}

class _$TextFileCaching extends _i163.TextFileCaching {}

class _$SharedPreferencesProvider extends _i301.SharedPreferencesProvider {}

class _$GetSavedLocale extends _i472.GetSavedLocale {}

class _$AppLocalizationsProvider extends _i211.AppLocalizationsProvider {}
