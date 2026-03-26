import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_appln/providers/weather_provider.dart';
import 'package:weather_appln/widgets/air_quality_card.dart';
import 'package:weather_appln/widgets/current_weather_card.dart';
import 'package:weather_appln/widgets/forecast_list.dart';
import 'package:weather_appln/widgets/weather_search_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: _gradientForCondition(
                  provider.currentWeather?.condition ?? 'Clear',
                ),
              ),
            ),
            child: SafeArea(
              child: RefreshIndicator(
                color: Colors.white,
                onRefresh: provider.refresh,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: WeatherSearchBar(
                            onSearch: (city) => provider.fetchWeather(city),
                          ),
                        ),
                        const SizedBox(width: 12),
                        _UnitToggleButton(
                          isFahrenheit: provider.isFahrenheit,
                          onTap: provider.toggleTemperatureUnit,
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    if (provider.isLoading)
                      const Padding(
                        padding: EdgeInsets.only(top: 100),
                        child: Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      )
                    else if (provider.errorMessage != null)
                      _ErrorState(
                        message: provider.errorMessage!,
                        onRetry: provider.refresh,
                      )
                    else if (provider.currentWeather != null)
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: Column(
                          key: ValueKey<String>(
                            provider.currentWeather!.cityName,
                          ),
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TweenAnimationBuilder<Offset>(
                              tween: Tween(
                                begin: const Offset(0, 0.1),
                                end: Offset.zero,
                              ),
                              duration: const Duration(milliseconds: 600),
                              builder: (context, value, child) {
                                return Transform.translate(
                                  offset: Offset(
                                    value.dx * 100,
                                    value.dy * 100,
                                  ),
                                  child: Opacity(opacity: 1 - value.dy, child: child),
                                );
                              },
                              child: CurrentWeatherCard(
                                weather: provider.currentWeather!,
                                iconUrl: provider.iconUrl(
                                  provider.currentWeather!.iconCode,
                                ),
                                temperatureText:
                                    '${provider.displayTemp(provider.currentWeather!.temperatureCelsius).toStringAsFixed(1)}°${provider.tempUnit}',
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              '5-Day Forecast',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ForecastList(
                              forecast: provider.forecast,
                              iconUrlFor: provider.iconUrl,
                              tempTextFor: (c) =>
                                  '${provider.displayTemp(c).toStringAsFixed(1)}°${provider.tempUnit}',
                            ),
                            const SizedBox(height: 18),
                            AirQualityCard(
                              aqi: provider.aqi,
                              label: provider.aqiLabel,
                            ),
                          ],
                        ),
                      )
                    else
                      const SizedBox.shrink(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _UnitToggleButton extends StatelessWidget {
  final bool isFahrenheit;
  final VoidCallback onTap;

  const _UnitToggleButton({
    required this.isFahrenheit,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.2),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Text(
            isFahrenheit ? '°F' : '°C',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withValues(alpha: 0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 36),
            const SizedBox(height: 12),
            Text(
              message,
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: onRetry,
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}

List<Color> _gradientForCondition(String condition) {
  switch (condition.toLowerCase()) {
    case 'rain':
    case 'drizzle':
    case 'thunderstorm':
      return [const Color(0xFF2C3E50), const Color(0xFF4CA1AF)];
    case 'clouds':
      return [const Color(0xFF485563), const Color(0xFF29323C)];
    case 'snow':
      return [const Color(0xFF83A4D4), const Color(0xFFB6FBFF)];
    default:
      return [const Color(0xFF3A7BD5), const Color(0xFF00D2FF)];
  }
}
