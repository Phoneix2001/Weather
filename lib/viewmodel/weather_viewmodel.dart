import 'package:flutter/material.dart';
import 'package:weather/model/weather.dart';
import 'package:weather/services/api_calling/data/app_exception.dart';
import 'package:weather/services/api_calling/data/response/api_response.dart';
import 'package:weather/services/location_service/fetch_lat_lng/fetch_lat_lng.dart';
import '../services/api_calling/repository/weather_repo.dart';

class WeatherViewModel extends ChangeNotifier {
  final WeatherRepo _repo = WeatherRepo();

  final TextEditingController searchController = TextEditingController();

  bool _isSearching = false;

  bool get isSearching => _isSearching;

  set isSearching(bool value) {
    _isSearching = value;
    notifyListeners();
  }

  ApiResponse<Weather> _weather = ApiResponse.loading();
  ApiResponse<Weather> get weather => _weather;

  set weather(ApiResponse<Weather> response) {
    _weather = response;
    notifyListeners();
  }

  Future<void> fetchWeather({
    String? location,
    String? lat,
    String? lng,
  }) async {
    weather = ApiResponse.loading();
    notifyListeners();
    try {
      final data = await _repo.fetchWeather(
        location: location,
        lng: lng,
        lat: lat,
      );

      if (data == null) {
        weather = ApiResponse.error(
          "Weather report unavailable — looks like even the clouds are shy today.",
        );
      }
      weather = ApiResponse.completed(data);
    } catch (e) {
      String decodedMessage;
      e.runtimeType;
      try {
        decodedMessage = (e as AppException).message["message"];
      } catch (e) {
        decodedMessage = "Something went wrong";
      }
      if (e is NoInternetException) {
        weather = ApiResponse.noInternet(decodedMessage);
        return;
      }
      weather = ApiResponse.error(decodedMessage);
    }
  }

  void onSearch(String city) {
    if (city.trim().isNotEmpty) {
      fetchWeather(location: city.trim());
      _isSearching = false;
      searchController.clear();
    }
  }

  void fetchLatLng(BuildContext context) {
    fetchCurrentLocation(context).then((position) {
      if (position != null) {
        fetchWeather(lat: "${position.latitude}", lng: "${position.longitude}");
      } else {
        weather = ApiResponse.error(
          "Please use the search bar to find your city.",
        );
      }
    });
  }

  void onPressSearch() {
    searchController.clear();
    isSearching = !isSearching;
  }
}
