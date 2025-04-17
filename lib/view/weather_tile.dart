import 'package:flutter/material.dart';
import '../model/weather.dart';

class WeatherTile extends StatefulWidget {
  final Weather weather;

  const WeatherTile({super.key, required this.weather});

  @override
  State<WeatherTile> createState() => _WeatherTileState();
}

class _WeatherTileState extends State<WeatherTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final weather = widget.weather;
    final weatherObj = weather.weather?.first;
    return Column(
      children: [
        FadeTransition(
          opacity: _fadeIn,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeOut,
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.indigo.shade300, Colors.blue.shade100],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(2, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  '${weather.main?.temp?.toStringAsFixed(1)}°C',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      'https://openweathermap.org/img/wn/${weatherObj?.icon}@2x.png',
                      scale: 1.2,
                    ),
                    SizedBox(width: 12),
                    Flexible(
                      child: Text(
                        _capitalize(weatherObj?.description ?? ""),
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(color: Colors.white54, thickness: 1, height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildDetailTile(
                      icon: Icons.air,
                      label: 'Wind',
                      value: '${weather.wind?.speed} m/s',
                    ),
                    _buildDetailTile(
                      icon: Icons.water_drop,
                      label: 'Humidity',
                      value: '${weather.main?.humidity}%',
                    ),
                    _buildDetailTile(
                      icon: Icons.visibility,
                      label: 'Visibility',
                      value:
                          '${((weather.visibility ?? 0) / 1000).toStringAsFixed(1)} km',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        SizedBox(height: 4),
        Text(value, style: TextStyle(color: Colors.white)),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.white70)),
      ],
    );
  }

  String _capitalize(String input) =>
      input.isNotEmpty ? input[0].toUpperCase() + input.substring(1) : '';
}
