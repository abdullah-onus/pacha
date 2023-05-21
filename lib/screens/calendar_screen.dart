import 'dart:core';
import 'dart:math';
import 'package:animations/animations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';
import 'package:pacha/globals.dart';
import 'package:pacha/models/calendar_event.dart';
import 'package:pacha/screens/events/event_editor.dart';
import 'package:pacha/screens/events/event_info.dart';
import 'package:pacha/settings.dart';

class ScreenCalendar extends StatefulWidget {
  const ScreenCalendar({Key? key}) : super(key: key);
  @override
  _ScreenCalendarState createState() => _ScreenCalendarState();
}

class _ScreenCalendarState extends State<ScreenCalendar> {
  final random = Random();
  DateTime startDate = DateTime.parse(Globals.challenge!.startDate!);
  DateTime endDate = DateTime.parse(Globals.challenge!.endDate!);
  DateTime initialDate = DateTime.parse(Globals.challenge!.startDate!);
  List<CalendarEvent> events = Globals().eventList;
  @override
  Widget build(BuildContext context) {
    String time = DateFormat.yMMMMd(Settings().getLanguage).format(initialDate.toLocal());
    return SafeArea(
      child: Scaffold(
        floatingActionButton: Visibility(
          visible: true, //Globals.user!.role == 'admin',
          child: OpenContainer(
              transitionDuration: const Duration(milliseconds: 700),
              middleColor: Colors.grey.shade800,
              openColor: Colors.grey.shade900,
              closedColor: Colors.transparent,
              closedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
              transitionType: ContainerTransitionType.fadeThrough,
              openBuilder: (BuildContext context, VoidCallback openContainer) {
                return const EventEditor();
              },
              closedBuilder: (BuildContext context, VoidCallback openContainer) {
                return FloatingActionButton(
                  onPressed: openContainer,
                  child: const Icon(Icons.add),
                );
              }),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              leading: IconButton(
                  onPressed: () {
                    setState(() {
                      if (initialDate.isAfter(startDate)) {
                        initialDate = initialDate.subtract(const Duration(days: 1));
                      }
                    });
                  },
                  icon: const Icon(Icons.arrow_back),
                  color: Colors.amber),
              title: Center(
                child: Text(
                  time,
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              subtitle: Center(
                child: Text(
                  AppLocalizations.of(context).screenScoreDailyTabDayPlaceHolder + ' ' + (initialDate.difference(startDate).inDays + 1).toString(),
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              trailing: IconButton(
                onPressed: () {
                  setState(() {
                    if (initialDate.isBefore(endDate)) {
                      initialDate = initialDate.add(const Duration(days: 1));
                    }
                  });
                },
                icon: const Icon(Icons.arrow_forward, color: Colors.amber),
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: events.length,
                itemBuilder: (BuildContext context, index) {
                  if ((events[index]
                              .startDate
                              .subtract(Duration(hours: events[index].startDate.hour, minutes: events[index].startDate.minute))
                              .isBefore(initialDate) ||
                          events[index]
                              .startDate
                              .subtract(Duration(hours: events[index].startDate.hour, minutes: events[index].startDate.minute))
                              .isAtSameMomentAs(initialDate)) &&
                      (events[index]
                              .endDate
                              .subtract(Duration(hours: events[index].endDate.hour, minutes: events[index].endDate.minute))
                              .isAfter(initialDate) ||
                          events[index]
                              .endDate
                              .subtract(Duration(hours: events[index].endDate.hour, minutes: events[index].endDate.minute))
                              .isAtSameMomentAs(initialDate))) {
                    return OpenContainer(
                        transitionDuration: const Duration(milliseconds: 700),
                        middleColor: Colors.grey.shade800,
                        openColor: Colors.grey.shade900,
                        closedColor: Colors.transparent.withOpacity(index < 10 ? index / 10 : (index % 10) / 10),
                        transitionType: ContainerTransitionType.fadeThrough,
                        openBuilder: (BuildContext context, VoidCallback openContainer) {
                          return EventInfo(event: events[index]);
                        },
                        closedBuilder: (BuildContext context, VoidCallback openContainer) {
                          return ListTile(
                            leading: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(DateFormat.Hm(Settings().getLanguage).format(events[index].startDate.toLocal()),
                                    style: Theme.of(context).textTheme.caption),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                      DateFormat.Hm(Settings().getLanguage).format(
                                        events[index].endDate.toLocal(),
                                      ),
                                      style: Theme.of(context).textTheme.caption),
                                ),
                              ],
                            ),
                            //tileColor: Color.fromARGB(random.nextInt(256), random.nextInt(256), random.nextInt(256), random.nextInt(256)),
                            title: MarkdownBody(data: events[index].title),
                            subtitle: Text(
                              events[index].description,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: openContainer,
                            shape: Border.all(width: 1, color: Colors.grey),
                          );
                        });
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
