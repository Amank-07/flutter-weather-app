import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_appln/models/forecast_item.dart';

class ForecastList extends StatelessWidget {
  final List<ForecastItem> forecast;
  final String Function(String iconCode) iconUrlFor;
  final String Function(double celsiusTemp) tempTextFor;

  const ForecastList({
    super.key,
    required this.forecast,
    required this.iconUrlFor,
    required this.tempTextFor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 145,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final item = forecast[index];
          return Container(
            width: 120,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat('EEE').format(item.dateTime),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Image.network(iconUrlFor(item.iconCode), width: 42, height: 42),
                const SizedBox(height: 8),
                Text(
                  tempTextFor(item.temperatureCelsius),
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemCount: forecast.length,
      ),
    );
  }
}
