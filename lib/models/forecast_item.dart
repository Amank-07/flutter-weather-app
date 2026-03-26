class ForecastItem {
  final DateTime dateTime;
  final double temperatureCelsius;
  final String condition;
  final String iconCode;

  ForecastItem({
    required this.dateTime,
    required this.temperatureCelsius,
    required this.condition,
    required this.iconCode,
  });

  factory ForecastItem.fromJson(Map<String, dynamic> json) {
    return ForecastItem(
      dateTime:
          DateTime.fromMillisecondsSinceEpoch((json['dt'] as int) * 1000),
      temperatureCelsius: (json['main']['temp'] as num).toDouble(),
      condition: json['weather'][0]['main'] as String,
      iconCode: json['weather'][0]['icon'] as String,
    );
  }
}
