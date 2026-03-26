class Weather {
  final String cityName;
  final double temperatureCelsius;
  final String condition;
  final int humidity;
  final double windSpeed;
  final String iconCode;
  final DateTime dateTime;
  final double latitude;
  final double longitude;

  Weather({
    required this.cityName,
    required this.temperatureCelsius,
    required this.condition,
    required this.humidity,
    required this.windSpeed,
    required this.iconCode,
    required this.dateTime,
    required this.latitude,
    required this.longitude,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'] as String,
      temperatureCelsius: (json['main']['temp'] as num).toDouble(),
      condition: json['weather'][0]['main'] as String,
      humidity: json['main']['humidity'] as int,
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      iconCode: json['weather'][0]['icon'] as String,
      dateTime:
          DateTime.fromMillisecondsSinceEpoch((json['dt'] as int) * 1000),
      latitude: (json['coord']['lat'] as num).toDouble(),
      longitude: (json['coord']['lon'] as num).toDouble(),
    );
  }
}
