// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import 'data/data_sources/quran_radio_channnels_data_sources/quran_radio_channels_remote_data_source.dart'
    as _i873;
import 'data/data_sources_imp/quran_radio_channnels_remote_data_source_imp.dart'
    as _i936;
import 'data/repositories_imp/quran_radio_channels_repository_imp.dart'
    as _i1060;
import 'data/services/apis/api_manager.dart' as _i265;
import 'domain/repositories/quran_radio_channels/quran_radio_channels_repository.dart'
    as _i602;
import 'presentation/modules/mainScreen/layouts/radio_layout/manager/radio_view_model.dart'
    as _i647;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.singleton<_i265.ApiManager>(() => _i265.ApiManager());
    gh.factory<_i873.QuranRadioChannelsRemoteDataSource>(() =>
        _i936.QuranRadioChannelsRemoteDataSourceImp(gh<_i265.ApiManager>()));
    gh.factory<_i602.QuranRadioChannelsRepository>(() =>
        _i1060.QuranRadioChannelsRepositoryImp(
            gh<_i873.QuranRadioChannelsRemoteDataSource>()));
    gh.factory<_i647.RadioViewModel>(
        () => _i647.RadioViewModel(gh<_i602.QuranRadioChannelsRepository>()));
    return this;
  }
}
