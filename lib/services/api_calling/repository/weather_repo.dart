import 'package:weather/model/weather.dart';
import 'package:weather/services/api_calling/app_url/app_url.dart';
import 'package:weather/services/api_calling/data/network/network_api_services.dart';

import '../../../utils/functions/logs.dart';

class WeatherRepo {
  Future<Weather?> fetchWeather({
    String? location,
    String? lat,
    String? lng,
  }) async {
    assert(
      location != null || (lat != null && lng != null),
      "Either location or both lat and lng must be provided",
    );

    NetworkApiService apiServices = NetworkApiService.instance;

    try {
      String url = "${AppUrl.weather}appid=${AppUrl.apiKey}&units=metric";
      if (location != null) {
        url += "&q=$location";
      }
      if (lat != null && lng != null) {
        url += "&lat=$lat&lon=$lng";
      }
      dynamic response = await apiServices.getResponse(url);

      return Weather.fromJson(response);
    } catch (e) {
      logE("error in SignIn repo", e.toString());
      rethrow;
    }
  }
}
