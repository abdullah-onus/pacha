import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class Utilities {
  static final Utilities _instance = Utilities._internal();
  factory Utilities() => _instance;
  Utilities._internal();
  String readableTimestamp(String timestamp, BuildContext context) {
    final difference = DateTime.now().difference(DateTime.parse(timestamp));
    if (difference.inSeconds <= 10) {
      return AppLocalizations.of(context).readableTimestampNow;
    } else if (difference.inSeconds <= 60) {
      return AppLocalizations.of(context).readableTimestampFewSeconds;
    } else if (difference.inSeconds <= 120) {
      return AppLocalizations.of(context).readableTimestampAMinutes;
    } else if (difference.inMinutes <= 30) {
      return AppLocalizations.of(context).readableTimestampInMinutes(difference.inMinutes);
    } else if (difference.inMinutes <= 35) {
      return AppLocalizations.of(context).readableTimestampHalfHour;
    } else if (difference.inMinutes <= 44) {
      return AppLocalizations.of(context).readableTimestampMoreHalfHour;
    } else if (difference.inMinutes <= 60) {
      return AppLocalizations.of(context).readableTimestampInMinutes(difference.inMinutes);
    } else if (difference.inHours <= 2) {
      return AppLocalizations.of(context).readableTimestampAHour;
    } else if (difference.inHours <= 4) {
      return AppLocalizations.of(context).readableTimestampFewHours;
    } else if (difference.inHours <= 12) {
      return AppLocalizations.of(context).readableTimestampInHours(difference.inHours);
    } else if (difference.inHours <= 13) {
      return AppLocalizations.of(context).readableTimestampHalfDay;
    } else if (difference.inHours <= 24) {
      return AppLocalizations.of(context).readableTimestampInHours(difference.inHours);
    } else if (difference.inDays < 7) {
      return AppLocalizations.of(context).readableTimestampInDays(difference.inDays);
    } else if (difference.inDays < 14) {
      return AppLocalizations.of(context).readableTimestampAWeek;
    } else if (difference.inDays < 21) {
      return AppLocalizations.of(context).readableTimestampTwoWeeks;
    } else if (difference.inDays < 28) {
      return AppLocalizations.of(context).readableTimestampThreeWeeks;
    } else if (difference.inDays <= 61) {
      return AppLocalizations.of(context).readableTimestampAMonth;
    } else if (difference.inDays <= 91) {
      return AppLocalizations.of(context).readableTimestampTwoMonths;
    } else {
      return AppLocalizations.of(context).readableTimestampInDays(difference.inDays);
    }
  }
}
