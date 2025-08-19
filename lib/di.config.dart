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

import 'data/data_sources/quran_radio_channnels_data_sources/quran_radio_channels_remote_data_source.dart'
    as _i873;
import 'data/data_sources_imp/quran_radio_channnels_remote_data_source_imp.dart'
    as _i936;
import 'data/repositories_imp/quran_radio_channels_repository_imp.dart'
    as _i1060;
import 'data/services/apis/api_manager.dart' as _i265;
import 'domain/repositories/quran_radio_channels/quran_radio_channels_repository.dart'
    as _i602;
import 'presentation/core/ads/ads_provider.dart' as _i140;
import 'presentation/core/ads/appodeal_ad_provider.dart' as _i504;
import 'presentation/core/ads/start_io_ad_provider.dart' as _i680;
import 'presentation/core/shared_preferences/shared_preferences_provider.dart'
    as _i596;
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
    final sharedPreferencesProvider = _$SharedPreferencesProvider();
    gh.factory<_i680.StartIoAdProvider>(() => _i680.StartIoAdProvider());
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => sharedPreferencesProvider.provide(),
      preResolve: true,
    );
    gh.singleton<_i265.ApiManager>(() => _i265.ApiManager());
    gh.lazySingleton<_i140.AdsProvider>(
      () => _i504.AppodealAdsProvider(),
      instanceName: 'AppodealAdsProvider',
    );
    gh.factory<_i70.SurahScreenProvider>(
        () => _i70.SurahScreenProvider(gh<_i460.SharedPreferences>()));
    gh.factory<_i545.MainScreenProvider>(
        () => _i545.MainScreenProvider(gh<_i460.SharedPreferences>()));
    gh.factory<_i873.QuranRadioChannelsRemoteDataSource>(() =>
        _i936.QuranRadioChannelsRemoteDataSourceImp(gh<_i265.ApiManager>()));
    gh.factory<_i602.QuranRadioChannelsRepository>(() =>
        _i1060.QuranRadioChannelsRepositoryImp(
            gh<_i873.QuranRadioChannelsRemoteDataSource>()));
    gh.singleton<_i647.RadioViewModel>(
        () => _i647.RadioViewModel(gh<_i602.QuranRadioChannelsRepository>()));
    return this;
  }
}

class _$SharedPreferencesProvider extends _i596.SharedPreferencesProvider {}
