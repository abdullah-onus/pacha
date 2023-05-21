class UnitSettings {
  String _temperature = '';
  String _weight = '';
  String _length = '';
  String _volume = '';
  String _liquid = '';
  String _airSpeed = '';
  String _waterSpeed = '';
  String _landSpeed = '';
  UnitSettings(
      {String temperature = '',
      String weight = '',
      String length = '',
      String volume = '',
      String liquid = '',
      String airSpeed = '',
      String waterSpeed = '',
      String landSpeed = ''}) {
    _temperature = temperature;
    _weight = weight;
    _length = length;
    _volume = volume;
    _liquid = liquid;
    _airSpeed = airSpeed;
    _waterSpeed = waterSpeed;
    _landSpeed = landSpeed;
  }
  UnitSettings.fromJson(Map<String, dynamic> json) {
    _temperature = json['temperature'];
    _weight = json['weight'];
    _length = json['length'];
    _volume = json['volume'];
    _liquid = json['liquid'];
    _airSpeed = json['air_speed'];
    _waterSpeed = json['water_speed'];
    _landSpeed = json['land_speed'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['temperature'] = _temperature;
    data['weight'] = _weight;
    data['length'] = _length;
    data['volume'] = _volume;
    data['liquid'] = _liquid;
    data['air_speed'] = _airSpeed;
    data['water_speed'] = _waterSpeed;
    data['land_speed'] = _landSpeed;
    return data;
  }

  String get temperature => _temperature;
  String get weight => _weight;
  String get length => _length;
  String get volume => _volume;
  String get liquid => _liquid;
  String get airSpeed => _airSpeed;
  String get waterSpeed => _waterSpeed;
  String get landSpeed => _landSpeed;
}
