# 🌦 Weather App (Flutter + Provider)

🚀 **Live APK:** https://tinyurl.com/49r3frur
👉 You can download and try the application directly on your Android device.

---

## 📱 Overview

A clean, beginner-friendly, production-style weather app built with Flutter.

---

## ✨ Features

* Search weather by city
* Current temperature, condition, humidity, wind speed
* Weather icon from API
* Date and time display
* Loading indicator while fetching
* Error handling (invalid city / network issue)
* 5-day forecast (horizontal list)
* Temperature unit toggle (C/F)
* Save last searched city using local storage
* Pull-to-refresh support
* Condition-based gradient background
* Basic smooth animations (fade/slide transitions)

---

## 🛠 Tech Stack

* Flutter (stable)
* Dart
* Provider (state management)
* `http` (API calls)
* `shared_preferences` (local storage)

---

## 📂 Project Structure

```
lib/
  main.dart
  models/
    weather.dart
    forecast_item.dart
  services/
    weather_service.dart
  providers/
    weather_provider.dart
  screens/
    home_screen.dart
  widgets/
    weather_search_bar.dart
    current_weather_card.dart
    forecast_list.dart
```

---

## ⚙️ Setup Instructions

1. Create a free API key from OpenWeatherMap
2. Open `lib/services/weather_service.dart`
3. Replace:

   ```
   YOUR_OPENWEATHER_API_KEY
   ```
4. Run:

   ```
   flutter pub get
   flutter run
   ```

---

## 💡 Notes

* Uses metric units (Celsius), Fahrenheit handled in-app
* Local storage saves last searched city & unit
* Pull-to-refresh fetches latest data
