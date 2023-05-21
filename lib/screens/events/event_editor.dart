import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pacha/globals.dart';
import 'package:pacha/models/calendar_event.dart';
import 'package:pacha/models/participants.dart';
import 'package:pacha/settings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pacha/constants.dart';

enum VotingMethod { public, private, participationsOnly }

class EventEditor extends StatefulWidget {
  const EventEditor({Key? key}) : super(key: key);
  @override
  _EventEditorState createState() => _EventEditorState();
}

class _EventEditorState extends State<EventEditor> {
  final textEditingControllerDateStartController = TextEditingController();
  final textEditingControllerDateEndController = TextEditingController();
  final textEditingControllerCheckInStartController = TextEditingController();
  final textEditingControllerCheckInEndController = TextEditingController();
  final textEditingControllerWhoCanInvite = TextEditingController();
  final textEditingControllerGuests = TextEditingController();
  final textEditingControllerMaxParticipations = TextEditingController();
  final textEditingControllerTitle = TextEditingController();
  final textEditingControllerLocation = TextEditingController();
  final textEditingControllerVoters = TextEditingController();
  final textEditingControllerDescription = TextEditingController();
  TimeOfDay selectedTime = const TimeOfDay(hour: 00, minute: 00);
  String whiteList = "0123456789";
  bool isOccupationEmpty = true;
  bool isRSVP = false;
  bool isCheck = false;
  bool isTime = false;
  String? dropdownValue;
  String? seeGuestList;
  String? chosenValue;
  String? currentValue;
  DateTime startDate = DateTime.parse(Globals.challenge!.startDate!);
  DateTime endDate = DateTime.parse(Globals.challenge!.endDate!);
  DateTime? eventStartDate;
  DateTime? eventEndDate;
  DateTime? checkInStartDate;
  DateTime? checkInEndDate;
  DateTimeRange? dateRange;
  final TimeOfDay initialTime = TimeOfDay.now();
  String guestNameText = '';
  String inviterNameText = '';
  String votersNameText = '';
  @override
  void initState() {
    super.initState();
  }

  bool isStartTimeEarlierThanEndTime(DateTime? eventStartDate, DateTime? eventEndDate) {
    if ((eventEndDate!.day == eventStartDate!.day && eventEndDate.month == eventStartDate.month)) {
      if (((eventStartDate.hour * 60 + eventStartDate.minute) < (eventEndDate.hour * 60 + eventEndDate.minute))) {
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }

  Future showTimePickerForStart() async {}
  Future showTimePickerForEnd() async {}
  _EventEditorState() {
    String? pattern = DateFormat.yMd(Settings().getLanguage).pattern;
    List patternPieces = [
      ...{...DateFormat.yMd(Settings().getLanguage).parsePattern(pattern!)}
    ];
    for (var field in patternPieces) {
      if (![
            DateFormat.ABBR_MONTH,
            DateFormat.ABBR_MONTH_DAY,
            DateFormat.ABBR_MONTH_WEEKDAY_DAY,
            DateFormat.ABBR_QUARTER,
            DateFormat.ABBR_STANDALONE_MONTH,
            DateFormat.ABBR_WEEKDAY,
            DateFormat.DAY,
            DateFormat.HOUR,
            DateFormat.HOUR24,
            DateFormat.HOUR24_MINUTE,
            DateFormat.HOUR24_MINUTE_SECOND,
            DateFormat.HOUR_GENERIC_TZ,
            DateFormat.HOUR_MINUTE,
            DateFormat.HOUR_MINUTE_GENERIC_TZ,
            DateFormat.HOUR_MINUTE_SECOND,
            DateFormat.HOUR_MINUTE_TZ,
            DateFormat.HOUR_TZ,
            DateFormat.MINUTE,
            DateFormat.MINUTE_SECOND,
            DateFormat.MONTH,
            DateFormat.MONTH_DAY,
            DateFormat.MONTH_WEEKDAY_DAY,
            DateFormat.NUM_MONTH,
            DateFormat.NUM_MONTH_DAY,
            DateFormat.NUM_MONTH_WEEKDAY_DAY,
            DateFormat.QUARTER,
            DateFormat.SECOND,
            DateFormat.STANDALONE_MONTH,
            DateFormat.WEEKDAY,
            DateFormat.YEAR,
            DateFormat.YEAR_ABBR_MONTH,
            DateFormat.YEAR_ABBR_MONTH_DAY,
            DateFormat.YEAR_ABBR_MONTH_WEEKDAY_DAY,
            DateFormat.YEAR_ABBR_QUARTER,
            DateFormat.YEAR_MONTH,
            DateFormat.YEAR_MONTH_DAY,
            DateFormat.YEAR_MONTH_WEEKDAY_DAY,
            DateFormat.YEAR_NUM_MONTH,
            DateFormat.YEAR_NUM_MONTH_DAY,
            DateFormat.YEAR_NUM_MONTH_WEEKDAY_DAY,
            DateFormat.YEAR_QUARTER
          ].contains(field.toString()) &&
          !whiteList.contains(field.toString())) whiteList += field.toString();
    }
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              leading: IconButton(
                onPressed: () {
                  Globals().guestNames = [];
                  Globals().inviterNames = [];
                  Globals().voterNames = [];
                  Globals().participantsState = [];
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close),
              ),
              title: Text(
                AppLocalizations.of(context).screenCalendarTitle,
              ),
              actions: [
                IconButton(onPressed: saveEvent, icon: const Icon(Icons.save)),
              ],
            ),
            body: LayoutBuilder(builder: (BuildContext context, BoxConstraints viewportConstraints) {
              return SingleChildScrollView(
                  child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: viewportConstraints.maxHeight,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding:
                                EdgeInsets.only(top: Constants().padding, left: Constants().padding, bottom: Constants().padding, right: Constants().padding),
                            child: TextFormField(
                              controller: textEditingControllerTitle,
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context).screenCalendarTextFieldTitleText,
                              ),
                            ),
                          ),
                          //StartDateTextField
                          Padding(
                            padding: EdgeInsets.only(left: Constants().padding, bottom: Constants().padding, right: Constants().padding),
                            child: Focus(
                              child: TextField(
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.datetime,
                                  readOnly: true,
                                  controller: textEditingControllerDateStartController,
                                  decoration: InputDecoration(
                                      labelText: AppLocalizations.of(context).screenCalendarEventStart,
                                      hintText: DateFormat.yMMMMd(Settings().getLanguage).add_Hm().pattern,
                                      suffixIcon: const Icon(Icons.calendar_today)),
                                  onTap: () async {
                                    var date = await showDatePicker(
                                      context: context,
                                      helpText: AppLocalizations.of(context).screenEventEditorStartDatePickerHelpMessage,
                                      initialDate: eventStartDate ?? startDate,
                                      firstDate: startDate,
                                      lastDate: eventEndDate ?? endDate,
                                    );
                                    if (date != null) {
                                      do {
                                        var time = await showTimePicker(
                                          context: context,
                                          initialEntryMode: TimePickerEntryMode.input,
                                          helpText: AppLocalizations.of(context).screenEventEditorStartTimePickerHelpMessage,
                                          initialTime: TimeOfDay(hour: (eventStartDate ?? startDate).hour, minute: (eventStartDate ?? startDate).minute),
                                        );
                                        if (time != null) {
                                          date = DateTime(date!.year, date.month, date.day, time.hour, time.minute);
                                        }
                                        if (time == null && !isStartTimeEarlierThanEndTime(date, eventEndDate ?? endDate)) {
                                          return;
                                        } else if (!isStartTimeEarlierThanEndTime(date, eventEndDate ?? endDate)) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).screenEventEditorTimePickerErrorMessage)));
                                          continue;
                                        } else if (time != null) {
                                          eventStartDate = DateTime(date!.year, date.month, date.day, time.hour, time.minute);
                                          textEditingControllerDateStartController.text =
                                              DateFormat.yMMMMd(Settings().getLanguage).add_Hm().format(eventStartDate!);
                                          return;
                                        } else {
                                          return;
                                        }
                                      } while (!isStartTimeEarlierThanEndTime(date, eventEndDate ?? endDate));
                                    }
                                  }),
                            ),
                          ),
                          //EndDateTextField
                          Padding(
                            padding: EdgeInsets.only(left: Constants().padding, bottom: Constants().padding, right: Constants().padding),
                            child: TextField(
                                readOnly: true,
                                controller: textEditingControllerDateEndController,
                                decoration: InputDecoration(
                                  labelText: AppLocalizations.of(context).screenCalendarEventEnd,
                                  hintText: DateFormat.yMMMMd(Settings().getLanguage).add_Hm().pattern,
                                  suffixIcon: const Icon(Icons.calendar_today),
                                ),
                                onTap: () async {
                                  var date = await showDatePicker(
                                    context: context,
                                    helpText: AppLocalizations.of(context).screenEventEditorEndDatePickerHelpMessage,
                                    initialDate: eventEndDate ?? eventStartDate ?? startDate,
                                    firstDate: eventStartDate ?? startDate,
                                    lastDate: endDate,
                                  );
                                  if (date != null) {
                                    do {
                                      var time = await showTimePicker(
                                        context: context,
                                        initialEntryMode: TimePickerEntryMode.input,
                                        helpText: AppLocalizations.of(context).screenEventEditorEndTimePickerHelpMessage,
                                        initialTime: TimeOfDay(hour: (eventEndDate ?? startDate).hour, minute: (eventEndDate ?? startDate).minute),
                                      );
                                      if (time != null) {
                                        date = DateTime(date!.year, date.month, date.day, time.hour, time.minute);
                                      }
                                      if (time == null && !isStartTimeEarlierThanEndTime(eventStartDate ?? startDate, date)) {
                                        return;
                                      } else if (!isStartTimeEarlierThanEndTime(eventStartDate ?? startDate, date)) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).screenEventEditorTimePickerErrorMessage)));
                                        continue;
                                      } else if (time != null) {
                                        eventEndDate = DateTime(date!.year, date.month, date.day, time.hour, time.minute);
                                        textEditingControllerDateEndController.text = DateFormat.yMMMMd(Settings().getLanguage).add_Hm().format(eventEndDate!);
                                        return;
                                      } else {
                                        return;
                                      }
                                    } while (!isStartTimeEarlierThanEndTime(eventStartDate ?? startDate, date));
                                  }
                                }),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: Constants().padding, bottom: Constants().padding, right: Constants().padding),
                            child: TextFormField(
                              controller: textEditingControllerLocation,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                suffixIcon: const Icon(Icons.location_on),
                                labelText: AppLocalizations.of(context).screenCalendarLocation,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: Constants().padding, bottom: Constants().padding, right: Constants().padding),
                            child: TextFormField(
                              controller: textEditingControllerDescription,
                              textInputAction: TextInputAction.next,
                              maxLines: 4,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                alignLabelWithHint: true,
                                labelText: AppLocalizations.of(context).screenCalendarDescription,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: Constants().padding, bottom: Constants().padding, right: Constants().padding),
                            child: Focus(
                              child: TextField(
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.datetime,
                                  readOnly: true,
                                  controller: textEditingControllerCheckInStartController,
                                  decoration: InputDecoration(
                                      labelText: AppLocalizations.of(context).screenCalendarEventStart,
                                      hintText: DateFormat.yMMMMd(Settings().getLanguage).add_Hm().pattern,
                                      suffixIcon: const Icon(Icons.calendar_today)),
                                  onTap: () async {
                                    var date = await showDatePicker(
                                      context: context,
                                      helpText: AppLocalizations.of(context).screenEventEditorStartDatePickerHelpMessage,
                                      initialDate: checkInStartDate ?? startDate,
                                      firstDate: startDate,
                                      lastDate: checkInEndDate ?? endDate,
                                    );
                                    if (date != null) {
                                      do {
                                        var time = await showTimePicker(
                                          context: context,
                                          initialEntryMode: TimePickerEntryMode.input,
                                          helpText: AppLocalizations.of(context).screenEventEditorStartTimePickerHelpMessage,
                                          initialTime: TimeOfDay(hour: (checkInStartDate ?? startDate).hour, minute: (checkInStartDate ?? startDate).minute),
                                        );
                                        if (time != null) {
                                          date = DateTime(date!.year, date.month, date.day, time.hour, time.minute);
                                        }
                                        if (time == null && !isStartTimeEarlierThanEndTime(date, checkInEndDate ?? endDate)) {
                                          return;
                                        } else if (!isStartTimeEarlierThanEndTime(date, checkInEndDate ?? endDate)) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).screenEventEditorTimePickerErrorMessage)));
                                          continue;
                                        } else if (time != null) {
                                          checkInStartDate = DateTime(date!.year, date.month, date.day, time.hour, time.minute);
                                          textEditingControllerCheckInStartController.text =
                                              DateFormat.yMMMMd(Settings().getLanguage).add_Hm().format(checkInStartDate!);
                                          return;
                                        } else {
                                          return;
                                        }
                                      } while (!isStartTimeEarlierThanEndTime(date, checkInEndDate ?? endDate));
                                    }
                                  }),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: Constants().padding, bottom: Constants().padding, right: Constants().padding),
                            child: TextField(
                                readOnly: true,
                                controller: textEditingControllerCheckInEndController,
                                decoration: InputDecoration(
                                  labelText: AppLocalizations.of(context).screenCalendarEventEnd,
                                  hintText: DateFormat.yMMMMd(Settings().getLanguage).add_Hm().pattern,
                                  suffixIcon: const Icon(Icons.calendar_today),
                                ),
                                onTap: () async {
                                  var date = await showDatePicker(
                                    context: context,
                                    helpText: AppLocalizations.of(context).screenEventEditorEndDatePickerHelpMessage,
                                    initialDate: checkInEndDate ?? checkInStartDate ?? startDate,
                                    firstDate: checkInStartDate ?? startDate,
                                    lastDate: endDate,
                                  );
                                  if (date != null) {
                                    do {
                                      var time = await showTimePicker(
                                        context: context,
                                        initialEntryMode: TimePickerEntryMode.input,
                                        helpText: AppLocalizations.of(context).screenEventEditorEndTimePickerHelpMessage,
                                        initialTime: TimeOfDay(hour: (checkInEndDate ?? startDate).hour, minute: (checkInEndDate ?? startDate).minute),
                                      );
                                      if (time != null) {
                                        date = DateTime(date!.year, date.month, date.day, time.hour, time.minute);
                                      }
                                      if (time == null && !isStartTimeEarlierThanEndTime(checkInStartDate ?? startDate, date)) {
                                        return;
                                      } else if (!isStartTimeEarlierThanEndTime(checkInStartDate ?? startDate, date)) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).screenEventEditorTimePickerErrorMessage)));
                                        continue;
                                      } else if (time != null) {
                                        checkInEndDate = DateTime(date!.year, date.month, date.day, time.hour, time.minute);
                                        textEditingControllerCheckInEndController.text =
                                            DateFormat.yMMMMd(Settings().getLanguage).add_Hm().format(checkInEndDate!);
                                        return;
                                      } else {
                                        return;
                                      }
                                    } while (!isStartTimeEarlierThanEndTime(checkInStartDate ?? startDate, date));
                                  }
                                }),
                          ),
                          Column(
                            children: [
                              Container(
                                padding: EdgeInsets.only(left: Constants().padding, bottom: Constants().padding, right: Constants().padding),
                                child: InputDecorator(
                                  decoration: InputDecoration(
                                    labelText: AppLocalizations.of(context).screenCalendarRewardIncentives,
                                    border: const OutlineInputBorder(),
                                  ),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: Constants().padding, right: Constants().padding),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Checkbox(
                                                    value: isRSVP,
                                                    onChanged: (bool? value) {
                                                      setState(() {
                                                        isRSVP = value!;
                                                      });
                                                    }),
                                                SizedBox(
                                                  width: MediaQuery.of(context).size.width / 3.4,
                                                  child: FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    child: Text(
                                                      AppLocalizations.of(context).screenCalendarRewardRSVP,
                                                      maxLines: 1,
                                                      textAlign: TextAlign.start,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Checkbox(
                                                    value: isCheck,
                                                    onChanged: (bool? value) {
                                                      setState(() {
                                                        isCheck = value!;
                                                      });
                                                    }),
                                                SizedBox(
                                                  width: MediaQuery.of(context).size.width / 3,
                                                  child: FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    child: Text(
                                                      AppLocalizations.of(context).screenCalendarRewardCheckin,
                                                      maxLines: 1,
                                                      textAlign: TextAlign.start,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Checkbox(
                                                    value: isTime,
                                                    onChanged: (bool? value) {
                                                      setState(() {
                                                        isTime = value!;
                                                      });
                                                    }),
                                                SizedBox(
                                                  width: MediaQuery.of(context).size.width / 1.7,
                                                  child: FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    child: Text(
                                                      AppLocalizations.of(context).screenCalendarRewardIncertiveTimelyCheckin,
                                                      maxLines: 1,
                                                      textAlign: TextAlign.start,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: Constants().padding, bottom: Constants().padding, right: Constants().padding),
                            child: DropdownButtonFormField<String>(
                              hint: Text(AppLocalizations.of(context).screenCalendarVotingMethod),
                              isExpanded: true,
                              value: dropdownValue,
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownValue = newValue!;
                                });
                              },
                              items: AppLocalizations.of(context).screenEventEditorDropDownVotingMethodList.split(",").map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                          Visibility(
                            visible: dropdownValue == null || dropdownValue!.isEmpty ? false : true,
                            child: Padding(
                              padding: EdgeInsets.only(left: Constants().padding, bottom: Constants().padding, right: Constants().padding),
                              child: TextField(
                                controller: textEditingControllerVoters,
                                textInputAction: TextInputAction.next,
                                readOnly: true,
                                onTap: () {
                                  Globals.pageIndex = 1;
                                  votersNameText = '';
                                  if (Globals().participantsState.isEmpty ||
                                      Globals().participantsState.any((object) => object.participants.contains('voters')) == false) {
                                    Globals().participantsState.add(Participants(
                                          participants: 'voters',
                                          selectedPeople: {},
                                        ));
                                    Navigator.of(context)
                                        .pushNamed(
                                      '/calendar/pick_people',
                                      arguments: Globals().participantsState.firstWhere((element) => element.participants == 'voters'),
                                    )
                                        .then((value) {
                                      List<String> names = value as List<String>;
                                      if (names.isEmpty) {
                                        return;
                                      } else {
                                        Globals().voterNames = names;
                                        for (String voterNames in Globals().voterNames) {
                                          votersNameText += '$voterNames ';
                                        }
                                        setState(() {});
                                      }
                                    });
                                  } else {
                                    Navigator.of(context)
                                        .pushNamed(
                                      '/calendar/pick_people',
                                      arguments: Globals().participantsState.firstWhere((element) => element.participants == 'voters'),
                                    )
                                        .then((value) {
                                      List<String> names = value as List<String>;
                                      if (names.isEmpty) {
                                        return;
                                      } else {
                                        Globals().voterNames = names;
                                        for (String voterNames in Globals().voterNames) {
                                          votersNameText += '$voterNames ';
                                        }
                                        setState(() {});
                                      }
                                    });
                                  }
                                },
                                decoration: InputDecoration(
                                    hintText: AppLocalizations.of(context).screenCalendarVoters,
                                    suffixIcon: const Icon(
                                      Icons.people,
                                      color: Colors.grey,
                                    )),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: votersNameText.isNotEmpty,
                            child: Padding(
                              padding: EdgeInsets.only(right: Constants().padding, left: Constants().padding, bottom: Constants().padding),
                              child: Text(
                                votersNameText,
                                style: Theme.of(context).textTheme.caption,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ),
                          Visibility(
                            visible: dropdownValue == null || dropdownValue!.isEmpty ? false : true,
                            child: Padding(
                              padding:
                                  EdgeInsets.only(right: Constants().padding, left: Constants().padding, bottom: Constants().padding, top: Constants().padding),
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  labelText: AppLocalizations.of(context).screenCalendarAwards,
                                  border: const OutlineInputBorder(),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Wrap(
                                    alignment: WrapAlignment.spaceEvenly,
                                    direction: Axis.horizontal,
                                    children: List.generate(
                                      10,
                                      (index) => Padding(
                                        padding: EdgeInsets.all(Constants().padding / 2),
                                        child: Container(
                                          padding: const EdgeInsets.all(0.0),
                                          width: (MediaQuery.of(context).size.width - 95) / 2,
                                          child: DropdownButtonFormField<String>(
                                            isExpanded: true,
                                            hint: Text(AppLocalizations.of(context).screenEventEditorDropDownAwards.split(",")[index]),
                                            items: AppLocalizations.of(context).screenEventEditorDropDownAwardsList.split(",").map((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                            onChanged: (String? value) {
                                              setState(() {
                                                chosenValue = value!;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Flexible(
                                child: Padding(
                                  padding: EdgeInsets.only(left: Constants().padding, bottom: Constants().padding, right: Constants().padding),
                                  child: TextFormField(
                                    controller: textEditingControllerMaxParticipations,
                                    textInputAction: TextInputAction.done,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(labelText: AppLocalizations.of(context).screenCalendarMaxParticipations),
                                  ),
                                ),
                              ),
                              Flexible(
                                  child: Padding(
                                padding: EdgeInsets.only(left: Constants().padding, bottom: Constants().padding, right: Constants().padding),
                                child: DropdownButtonFormField<String>(
                                    hint: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(AppLocalizations.of(context).screenCalendarSeeGuestList),
                                    ),
                                    isExpanded: true,
                                    value: seeGuestList,
                                    items: AppLocalizations.of(context).screenEventEditorDropDownSeeGuestList.split(",").map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (String? value) {
                                      setState(() {
                                        seeGuestList = value;
                                      });
                                    }),
                              ))
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: Constants().padding, bottom: Constants().padding, right: Constants().padding),
                            child: TextField(
                                controller: textEditingControllerWhoCanInvite,
                                textInputAction: TextInputAction.next,
                                readOnly: true,
                                onTap: () {
                                  Globals.pageIndex = 2;
                                  inviterNameText = '';
                                  if (Globals().participantsState.isEmpty ||
                                      Globals().participantsState.any((object) => object.participants.contains('invite')) == false) {
                                    Globals().participantsState.add(Participants(
                                          participants: 'invite',
                                          selectedPeople: {},
                                        ));
                                    Navigator.of(context)
                                        .pushNamed(
                                      '/calendar/pick_people',
                                      arguments: Globals().participantsState.firstWhere((element) => element.participants == 'invite'),
                                    )
                                        .then((value) {
                                      List<String> names = value as List<String>;
                                      if (names.isEmpty) {
                                        return;
                                      } else {
                                        Globals().inviterNames = names;
                                        for (String inviterNames in Globals().inviterNames) {
                                          inviterNameText += '$inviterNames ';
                                        }
                                        setState(() {});
                                      }
                                    });
                                  } else {
                                    Navigator.of(context)
                                        .pushNamed(
                                      '/calendar/pick_people',
                                      arguments: Globals().participantsState.firstWhere((element) => element.participants == 'invite'),
                                    )
                                        .then((value) {
                                      List<String> names = value as List<String>;
                                      if (names.isEmpty) {
                                        return;
                                      } else {
                                        Globals().inviterNames = names;
                                        for (String inviterNames in Globals().inviterNames) {
                                          inviterNameText += '$inviterNames ';
                                        }
                                      }
                                      setState(() {});
                                    });
                                  }
                                },
                                decoration: InputDecoration(
                                    hintText: AppLocalizations.of(context).screenCalendarWhoCanInvite,
                                    suffixIcon: const Icon(
                                      Icons.people,
                                      color: Colors.grey,
                                    ))),
                          ),
                          Visibility(
                            visible: inviterNameText.isNotEmpty,
                            child: Padding(
                              padding: EdgeInsets.only(right: Constants().padding, left: Constants().padding, bottom: Constants().padding),
                              child: Text(
                                Globals().inviterNames.isEmpty ? AppLocalizations.of(context).screenSignupTextFildDateOfBirthDescription : inviterNameText,
                                style: Theme.of(context).textTheme.caption,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: Constants().padding, bottom: Constants().padding, right: Constants().padding),
                            child: TextField(
                              controller: textEditingControllerGuests,
                              textInputAction: TextInputAction.next,
                              readOnly: true,
                              onTap: () {
                                Globals.pageIndex = 3;
                                guestNameText = '';
                                if (Globals().participantsState.isEmpty ||
                                    Globals().participantsState.any((object) => object.participants.contains('guest')) == false) {
                                  Globals().participantsState.add(Participants(
                                        participants: 'guest',
                                        selectedPeople: {},
                                      ));
                                  Navigator.of(context)
                                      .pushNamed(
                                    '/calendar/pick_people',
                                    arguments: Globals().participantsState.firstWhere((element) => element.participants == 'guest'),
                                  )
                                      .then((value) {
                                    List<String> names = value as List<String>;
                                    if (names.isEmpty) {
                                      return;
                                    } else {
                                      Globals().guestNames = names;
                                      for (String guestName in Globals().guestNames) {
                                        guestNameText += '$guestName ';
                                      }
                                      setState(() {});
                                    }
                                  });
                                } else {
                                  Navigator.of(context)
                                      .pushNamed(
                                    '/calendar/pick_people',
                                    arguments: Globals().participantsState.firstWhere((element) => element.participants == 'guest'),
                                  )
                                      .then((value) {
                                    List<String> names = value as List<String>;
                                    if (names.isEmpty) {
                                      return;
                                    } else {
                                      Globals().guestNames = names;
                                      for (String guestName in Globals().guestNames) {
                                        guestNameText += '$guestName ';
                                      }
                                      setState(() {});
                                    }
                                  });
                                }
                              },
                              decoration: InputDecoration(
                                  hintText: AppLocalizations.of(context).screenCalendarGuests,
                                  suffixIcon: const Icon(
                                    Icons.people,
                                    color: Colors.grey,
                                  )),
                            ),
                          ),
                          Visibility(
                            visible: guestNameText.isNotEmpty,
                            child: Padding(
                              padding: EdgeInsets.only(right: Constants().padding, left: Constants().padding, bottom: Constants().padding),
                              child: Text(
                                Globals().guestNames.isEmpty ? AppLocalizations.of(context).screenSignupTextFildDateOfBirthDescription : guestNameText,
                                style: Theme.of(context).textTheme.caption,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ),
                        ],
                      )));
            })));
  }

  @override
  void dispose() {
    super.dispose();
  }

  buildPhysicalEventDetails() {}
  bool checkMandatoriesSections() {
    return textEditingControllerDateStartController.text.isEmpty || isOccupationEmpty;
  }

  bool checkMandatoriesEndSections() {
    return textEditingControllerDateEndController.text.isEmpty || isOccupationEmpty;
  }

  void saveEvent() {
    if (textEditingControllerTitle.text.isEmpty ||
        textEditingControllerDescription.text.isEmpty ||
        eventStartDate == null ||
        eventEndDate == null ||
        checkInStartDate == null ||
        checkInEndDate == null ||
        textEditingControllerLocation.text.isEmpty ||
        textEditingControllerMaxParticipations.text.isEmpty ||
        seeGuestList == null ||
        seeGuestList!.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Some fields are missing"),
            content: const Text("Please fill empty fields"),
            actions: [
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        },
      );
    } else {
      Globals().addEvent(CalendarEvent(
        title: textEditingControllerTitle.text,
        description: textEditingControllerDescription.text,
        startDate: eventStartDate!,
        endDate: eventEndDate!,
        checkInStart: checkInStartDate!,
        checkInEnd: checkInEndDate!,
        location: textEditingControllerLocation.text,
        maxParticipations: textEditingControllerMaxParticipations.text,
        rewardRSVP: isRSVP,
        rewardCheckIn: isCheck,
        rewardtimelyCheckIn: isTime,
        votingMethod: dropdownValue!,
        voters: votersNameText,
        guestList: guestNameText,
        agents: inviterNameText,
        seeGuestList: seeGuestList!,
      ));
      Globals().guestNames = [];
      Globals().inviterNames = [];
      Globals().voterNames = [];
      Globals().participantsState = [];
      Navigator.pop(context);
    }
  }
}
