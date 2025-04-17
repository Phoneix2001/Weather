import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:weather/services/api_calling/data/response/status.dart';
import 'package:weather/view/address_auto_complete_field.dart';
import 'package:weather/viewmodel/weather_viewmodel.dart';
import '../utils/constants/constants.dart';
import 'weather_tile.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<WeatherViewModel>();
    provider.fetchLatLng(context);
    return Consumer<WeatherViewModel>(
      builder: (context, vm, child) {
        return Scaffold(
          appBar: AppBar(
            title:
                vm.isSearching
                    ? AddressAutoCompleteField(
                      controller: vm.searchController,
                      focusNode: FocusNode(),
                      onSelect: (p0) {},
                      prediction: cities,
                      onSearch: vm.onSearch,
                    )
                    : Text('Weather'),
            actions: [
              IconButton(
                icon: Icon(vm.isSearching ? Icons.close : Icons.search),
                onPressed: () => vm.onPressSearch(),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: switch (vm.weather.status) {
              Status.loading => const Center(
                child: SizedBox(
                  height: 50,
                  width: 50,
                  child: CircularProgressIndicator(strokeWidth: 6),
                ),
              ),

              Status.completed => WeatherTile(weather: vm.weather.data!),

              Status.error => errorMessage(vm.weather.message),

              Status.noInternet => noInternetError(),
            },
          ),
        );
      },
    );
  }

  Center noInternetError() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.wifi_off, color: Colors.grey, size: 48),
          SizedBox(height: 10),
          Text(
            "No internet connection!\nTry again later.",
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget errorMessage(String? mess) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.error_outline, color: Colors.red, size: 48),
        SizedBox(height: 10),
        Text(
          mess ?? "Something went wrong",
          style: TextStyle(color: Colors.red),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
