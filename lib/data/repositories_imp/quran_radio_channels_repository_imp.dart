import 'package:injectable/injectable.dart';
import 'package:islamy_app/data/data_sources/quran_radio_channnels_data_sources/quran_radio_channels_remote_data_source.dart';
import 'package:islamy_app/data/models/quran_radio_model.dart';
import 'package:islamy_app/domain/api_result/api_result.dart';
import 'package:islamy_app/domain/repositories/quran_radio_channels/quran_radio_channels_repository.dart';

@Injectable(as: QuranRadioChannelsRepository)
class QuranRadioChannelsRepositoryImp implements QuranRadioChannelsRepository {
  QuranRadioChannelsRemoteDataSource remoteDataSource;

  @factoryMethod
  QuranRadioChannelsRepositoryImp(this.remoteDataSource);

  @override
  Future<ApiResult<List<RadioChannel>>> getQuranRadioChannels(
      String languageCode) {
    return remoteDataSource.getQuranRadioChannels(languageCode);
  }
}
