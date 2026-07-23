class ApiConstants {
  // Android Emulator (same PC par FastAPI local run ho raha ho)
  static const String emulatorUrl = "http://10.0.2.2:8000";

  // Physical phone + same WiFi par FastAPI local run ho raha ho
  static const String wifiUrl = "http://192.168.1.100:8000";

  // Render deployed API
  static const String productionUrl = "https://mychatapp-d6wg.onrender.com";

  static const String baseUrl = productionUrl;
}