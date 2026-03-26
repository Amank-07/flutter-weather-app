import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_appln/models/weather.dart';

class CurrentWeatherCard extends StatelessWidget {
  final Weather weather;
  final String iconUrl;
  final String temperatureText;

  const CurrentWeatherCard({
    super.key,
    required this.weather,
    required this.iconUrl,
    required this.temperatureText,
  });

  @override
  Widget build(BuildContext context) {
    final dateText = DateFormat('EEE, dd MMM yyyy • hh:mm a').format(
      weather.dateTime,
    );

    return Card(
      elevation: 8,
      color: Colors.white.withValues(alpha: 0.14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              weather.cityName,
              style: const TextStyle(
                fontSize: 26,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              dateText,
              style: TextStyle(color: Colors.white.withValues(alpha: 0.85)),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Image.network(iconUrl, width: 72, height: 72),
                const SizedBox(width: 10),
                Text(
                  temperatureText,
                  style: const TextStyle(
                    fontSize: 44,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              weather.condition,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _InfoTile(
                  icon: Icons.water_drop,
                  title: 'Humidity',
                  value: '${weather.humidity}%',
                ),
                _InfoTile(
                  icon: Icons.air,
                  title: 'Wind',
                  value: '${weather.windSpeed} m/s',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(color: Colors.white.withValues(alpha: 0.8)),
            ),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
