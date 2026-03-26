import 'package:flutter/material.dart';

class AirQualityCard extends StatelessWidget {
  final int? aqi;
  final String label;

  const AirQualityCard({
    super.key,
    required this.aqi,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final score = aqi ?? 0;
    final color = _aqiColor(score);

    return Card(
      elevation: 8,
      color: Colors.white.withValues(alpha: 0.14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.air, color: color),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Air Quality Index',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'AQI: ${aqi ?? '-'} • $label',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.92),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Color _aqiColor(int aqi) {
  switch (aqi) {
    case 1:
      return const Color(0xFF2ECC71);
    case 2:
      return const Color(0xFF7ED957);
    case 3:
      return const Color(0xFFF1C40F);
    case 4:
      return const Color(0xFFE67E22);
    case 5:
      return const Color(0xFFE74C3C);
    default:
      return Colors.white;
  }
}
