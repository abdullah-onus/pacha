class LocaleSettings {
  String _language = '';
  String _country = '';
  String? _script = '';
  String _string = '';
  LocaleSettings({
    String language = '',
    String country = '',
    String script = '',
    String string = '',
  }) {
    _language = language;
    _country = country;
    _script = script;
    _string = string;
  }
  LocaleSettings.fromJson(Map<String, dynamic> json) {
    _language = json['language'];
    _country = json['country'];
    _script = json['script'];
    _string = json['string'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['language'] = _language;
    data['country'] = _country;
    data['script'] = _script;
    data['string'] = _string;
    return data;
  }

  String get language => _language;
  String get country => _country;
  String? get script => _script;
  String get string => _string;
}
