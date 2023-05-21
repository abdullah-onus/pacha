import 'package:flutter/material.dart';

class Constants {
  static final Constants _instance = Constants._internal();
  factory Constants() => _instance;
  static const int _resendTime = 60;
  static const double _padding = 16;
  static const _appBarBackIcon = Icon(Icons.arrow_back);
  Constants._internal();
  get resendTime => _resendTime;
  get padding => _padding;
  get appBarBackIcon => _appBarBackIcon;
}
