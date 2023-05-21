import 'package:pacha/models/local_settings.dart';
import 'package:pacha/models/unit_settings.dart';

class UserSettings {
  LocaleSettings _locale = LocaleSettings();
  String _theme = '';
  String _fontScaling = '';
  UnitSettings _units = UnitSettings();
  LocaleSettings get locale => _locale;
  String get theme => _theme;
  String get fontScaling => _fontScaling;
  UnitSettings get units => _units;
  UserSettings.fromJson(Map<String, dynamic> json) {
    if (json['locale'] != null) _locale = LocaleSettings.fromJson(json['locale']);
    _theme = json['theme'];
    _fontScaling = json['font_scaling'];
    if (json['units'] != null) _units = UnitSettings.fromJson(json['units']);
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['locale'] = _locale.toJson();
    data['theme'] = _theme;
    data['font_scaling'] = _fontScaling;
    data['units'] = _units.toJson();
    return data;
  }
}
