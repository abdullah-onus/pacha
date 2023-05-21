import 'package:pacha/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings {
  static final themes = {'pacha': PachaTheme.get};
  static final Settings _instance = Settings._internal();
  static SharedPreferences? sharedPreferences;
  // Database value keys
  static final values = {
    'temperature': ['c', 'f', 'k'],
    'theme': ['pacha', 'dark'],
    'length': ['metrik', 'abd_native', 'imperial'],
    'hourcycle': ['24', '12'],
    'weight': ['kg', 'lbs', 'pound'],
    'volume': ['liter', 'x', 'y'],
    'fontScale': ['small', 'normal', 'large', 'huge', 'system_defined'],
    'language': ['en_us', 'en_uk', 'tr_tr'],
  };
  factory Settings() => _instance;
  Settings._internal();
  init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  get getTheme => sharedPreferences?.getString('theme') ?? 'pacha';
  get getThemeData => themes[getTheme];
  String? getString(String key) => sharedPreferences?.getString(key);
  set setTheme(String theme) => sharedPreferences?.setString('theme', theme);
  get getFontScale => sharedPreferences!.getString('fontScale') ?? 'normal';
  set setFontScale(String fontScale) => sharedPreferences!.setString('fontScale', fontScale);
  get getLanguage => sharedPreferences!.getString('language') ?? 'en_us';
  set setLanguage(String language) => sharedPreferences!.setString('language', language);
  set setLanguageCode(String languageCode) => sharedPreferences!.setString('languageCode', languageCode);
  get getLanguageCode => sharedPreferences!.getString('languageCode') ?? 'en';
  set setCountryCode(String countryCode) => sharedPreferences!.setString('countryCode', countryCode);
  get getCountryCode => sharedPreferences!.getString('countryCode') ?? 'us';
  get getHourCycle => sharedPreferences!.getString('hourCycle') ?? '24';
  set setHourCycle(String hourcycle) => sharedPreferences!.setString('hourCycle', hourcycle);
  get getLength => sharedPreferences!.getString('length') ?? 'metrik';
  set setLength(String length) => sharedPreferences!.setString('length', length);
  get getTemperature => sharedPreferences!.getString('temperature') ?? 'c';
  set setTemperature(String temperature) => sharedPreferences!.setString('temperature', temperature);
  get getVolume => sharedPreferences!.getString('volume') ?? 'liter';
  set setVolume(String volume) => sharedPreferences!.setString('volume', volume);
  get getWeight => sharedPreferences!.getString('weight') ?? 'kg';
  set setWeight(String weight) => sharedPreferences!.setString('weight', weight);
}
