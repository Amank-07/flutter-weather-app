import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_appln/models/forecast_item.dart';
import 'package:weather_appln/models/weather.dart';
import 'package:weather_appln/services/weather_service.dart';

class WeatherProvider extends ChangeNotifier {
  final WeatherService _service = WeatherService();

  Weather? _currentWeather;
  List<ForecastItem> _forecast = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _lastSearchedCity = 'London';
  bool _isFahrenheit = false;
  int? _aqi;

  Weather? get currentWeather => _currentWeather;
  List<ForecastItem> get forecast => _forecast;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get lastSearchedCity => _lastSearchedCity;
  bool get isFahrenheit => _isFahrenheit;
  int? get aqi => _aqi;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _lastSearchedCity = prefs.getString('last_city') ?? 'London';
    _isFahrenheit = prefs.getBool('is_fahrenheit') ?? false;
    await fetchWeather(_lastSearchedCity);
  }

  Future<void> fetchWeather(String city) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final weather = await _service.fetchCurrentWeather(city);
      final forecast = await _service.fetchForecast(city);
      final airQuality = await _service.fetchAirQuality(
        latitude: weather.latitude,
        longitude: weather.longitude,
      );

      _currentWeather = weather;
      _forecast = forecast;
      _aqi = airQuality;
      _lastSearchedCity = city;
      await _saveLastCity(city);
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await fetchWeather(_lastSearchedCity);
  }

  Future<void> toggleTemperatureUnit() async {
    _isFahrenheit = !_isFahrenheit;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_fahrenheit', _isFahrenheit);
    notifyListeners();
  }

  double displayTemp(double celsius) {
    if (_isFahrenheit) {
      return (celsius * 9 / 5) + 32;
    }
    return celsius;
  }

  String get tempUnit => _isFahrenheit ? 'F' : 'C';

  String get aqiLabel {
    switch (_aqi) {
      case 1:
        return 'Good';
      case 2:
        return 'Fair';
      case 3:
        return 'Moderate';
      case 4:
        return 'Poor';
      case 5:
        return 'Very Poor';
      default:
        return 'N/A';
    }
  }

  String iconUrl(String iconCode) => _service.iconUrl(iconCode);

  Future<void> _saveLastCity(String city) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_city', city);
  }
}
