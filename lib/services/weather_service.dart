import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:weather_appln/models/forecast_item.dart';
import 'package:weather_appln/models/weather.dart';

class WeatherService {
  // Replace this with your own OpenWeatherMap API key.
  static const String _apiKey = '446361162880ad149208c47bba4cf540';
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';

  Future<Weather> fetchCurrentWeather(String city) async {
    final uri = Uri.parse(
      '$_baseUrl/weather?q=$city&appid=$_apiKey&units=metric',
    );
    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 12));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return Weather.fromJson(data);
      } else if (response.statusCode == 404) {
        throw Exception('City not found. Please enter a valid city name.');
      } else if (response.statusCode == 401) {
        throw Exception('Invalid API key. Please check your OpenWeather key.');
      } else if (response.statusCode == 429) {
        throw Exception('API limit reached. Please try again later.');
      } else {
        final dynamic parsed = jsonDecode(response.body);
        final apiMessage = parsed is Map<String, dynamic>
            ? parsed['message'] as String?
            : null;
        throw Exception(
          apiMessage ?? 'Failed to fetch weather data. Please try again.',
        );
      }
    } on SocketException {
      throw Exception('No internet connection. Please check your network.');
    } on HttpException {
      throw Exception('Unable to reach weather service right now.');
    } on FormatException {
      throw Exception('Unexpected response from weather service.');
    } on TimeoutException {
      throw Exception('Request timed out. Please try again.');
    }
  }

  Future<List<ForecastItem>> fetchForecast(String city) async {
    final uri = Uri.parse(
      '$_baseUrl/forecast?q=$city&appid=$_apiKey&units=metric',
    );
    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 12));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> list = data['list'] as List<dynamic>;

        // OpenWeather gives forecast in 3-hour blocks.
        // Picking every 8th item gives a rough daily forecast for 5 days.
        final selected = <ForecastItem>[];
        for (int i = 0; i < list.length && selected.length < 5; i += 8) {
          selected.add(ForecastItem.fromJson(list[i] as Map<String, dynamic>));
        }
        return selected;
      } else if (response.statusCode == 404) {
        throw Exception('City not found for forecast.');
      } else if (response.statusCode == 401) {
        throw Exception('Invalid API key. Please check your OpenWeather key.');
      } else if (response.statusCode == 429) {
        throw Exception('API limit reached. Please try again later.');
      } else {
        throw Exception('Failed to fetch forecast data.');
      }
    } on SocketException {
      throw Exception('No internet connection. Please check your network.');
    } on TimeoutException {
      throw Exception('Request timed out. Please try again.');
    }
  }

  Future<int> fetchAirQuality({
    required double latitude,
    required double longitude,
  }) async {
    final uri = Uri.parse(
      '$_baseUrl/air_pollution?lat=$latitude&lon=$longitude&appid=$_apiKey',
    );

    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 12));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> list = data['list'] as List<dynamic>;
        if (list.isEmpty) {
          throw Exception('Air quality data not available for this city.');
        }
        return (list.first['main']['aqi'] as num).toInt();
      } else if (response.statusCode == 401) {
        throw Exception('Invalid API key. Please check your OpenWeather key.');
      } else if (response.statusCode == 429) {
        throw Exception('API limit reached. Please try again later.');
      } else {
        throw Exception('Failed to fetch air quality data.');
      }
    } on SocketException {
      throw Exception('No internet connection. Please check your network.');
    } on TimeoutException {
      throw Exception('Request timed out. Please try again.');
    }
  }

  String iconUrl(String iconCode) {
    return 'https://openweathermap.org/img/wn/$iconCode@2x.png';
  }
}
