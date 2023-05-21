import 'dart:ui';
import 'package:pacha/models/calendar_event.dart';
import 'package:pacha/models/participants.dart';
import 'package:pacha/models/user_details.dart';
import 'package:pacha/models/challenge_details.dart';
import 'package:pacha/models/user_list.dart';

class Globals {
  static final Globals _instance = Globals._internal();
  factory Globals() => _instance;
  Globals._internal();
  static late List<CalendarEvent> _eventList = [];
  List<CalendarEvent> get eventList {
    return _eventList;
  }

  set setEventList(List<CalendarEvent> eventList) {
    _eventList = eventList;
  }

  List<String> guestNames = [];
  List<String> inviterNames = [];
  List<String> voterNames = [];
  List<Participants> participantsState = [];
  void addEvent(CalendarEvent event) {
    _eventList.add(event);
  }

  static UserDetails? user;
  static Locale? userLocale;
  static ChallengeDetails? challenge;
  static UserList? userList;
  static int pageIndex = 0;
}
