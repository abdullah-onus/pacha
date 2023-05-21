class CalendarEvent {
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String location;
  final DateTime checkInStart;
  final DateTime checkInEnd;
  final bool rewardRSVP;
  final bool rewardCheckIn;
  final bool rewardtimelyCheckIn;
  final String votingMethod;
  final String voters;
  final String maxParticipations;
  final String guestList;
  final String agents;
  final String seeGuestList;
  CalendarEvent({
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.checkInStart,
    required this.checkInEnd,
    required this.rewardRSVP,
    required this.rewardCheckIn,
    required this.rewardtimelyCheckIn,
    required this.votingMethod,
    required this.voters,
    required this.maxParticipations,
    required this.guestList,
    required this.agents,
    required this.seeGuestList,
  });
}
