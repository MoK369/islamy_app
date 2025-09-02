import 'package:injectable/injectable.dart';
import 'package:islamy_app/data/data_sources/quran_radio_channnels_data_sources/quran_radio_channels_remote_data_source.dart';
import 'package:islamy_app/data/models/quran_radio_model.dart';
import 'package:islamy_app/data/services/apis/api_manager.dart';
import 'package:islamy_app/domain/api_result/api_result.dart';

@Injectable(as: QuranRadioChannelsRemoteDataSource)
class QuranRadioChannelsRemoteDataSourceImp
    implements QuranRadioChannelsRemoteDataSource {
  ApiManager apiManager;

  //constructor injection
  @factoryMethod
  QuranRadioChannelsRemoteDataSourceImp(this.apiManager);

  @override
  Future<ApiResult<List<RadioChannel>>> getQuranRadioChannels(
      String languageCode) {
    return apiManager.getQuranRadioChannels(languageCode);
  }
}
