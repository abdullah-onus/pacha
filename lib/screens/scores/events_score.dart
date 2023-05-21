import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:pacha/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pacha/globals.dart';
import 'package:pacha/pacha_api.dart';
import 'package:pacha/screens/profile/profile_page.dart';

class EventScore extends StatefulWidget {
  const EventScore({Key? key}) : super(key: key);
  @override
  State<EventScore> createState() => _EventScoreState();
}

enum Status { none, running, done, error }

class _EventScoreState extends State<EventScore> with AutomaticKeepAliveClientMixin<EventScore> {
  @override
  bool get wantKeepAlive => true;
  Status status = Status.none;
  int? eventIndex = -1;
  int? categoryIndex = -1;
  List<dynamic> userEventScoreList = [];
  List<String> events = [
    'Photo shoot',
    'Swimming',
    'Race',
    'Model',
    'HAHA',
    'Mert',
    'wddfvbbr'
        'abc'
  ];
  _getEventScoreBoard({String? startDate, String? endDate, int? event, int? category}) {
    status = Status.running;
    PaChaAPI().userScoreList(challengeId: Globals.challenge!.id!, category: category, startDate: startDate, endDate: endDate, event: event).then((response) {
      Map<String, dynamic> json = (response as Map)['json'];
      setState(() {
        userEventScoreList.addAll((json['results'] as List));
        status = Status.done;
      });
    }).onError((error, stackTrace) {
      setState(() {
        userEventScoreList.clear();
        status = Status.error;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(left: Constants().padding, top: Constants().padding, right: Constants().padding),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: Constants().padding),
              child: DropdownButtonFormField<String>(
                isExpanded: true,
                items: events.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).screenScoreEventTabDropDownHintText,
                ),
                onChanged: (String? value) {
                  setState(() {
                    eventIndex = value == '' ? null : events.indexOf(value!);
                    userEventScoreList.clear();
                    if (eventIndex != -1 && categoryIndex != -1) {
                      _getEventScoreBoard(event: eventIndex, category: categoryIndex);
                    } else {
                      _getEventScoreBoard(event: eventIndex);
                    }
                  });
                },
              ),
            ),
            Visibility(
              visible: eventIndex != -1,
              child: DropdownButtonFormField<String>(
                isExpanded: true,
                items: AppLocalizations.of(context).screenCalendarCategoryList.split(",").map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: AppLocalizations.of(context).screenCalendarCategoryFieldText),
                onChanged: (String? value) {
                  setState(() {
                    categoryIndex = value == '' ? null : AppLocalizations.of(context).screenCalendarCategoryList.split(",").indexOf(value!);
                    if (eventIndex != -1 && categoryIndex != -1) {
                      userEventScoreList.clear();
                      _getEventScoreBoard(category: categoryIndex, event: eventIndex);
                    } else {
                      userEventScoreList.clear();
                      _getEventScoreBoard(category: categoryIndex);
                    }
                  });
                },
              ),
            ),
            eventIndex == -1 && categoryIndex == -1
                ? Container()
                : Expanded(
                    child: status == Status.running
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : Padding(
                            padding: EdgeInsets.only(
                              top: Constants().padding,
                            ),
                            child: ListView.builder(
                              itemCount: userEventScoreList.length,
                              itemBuilder: (context, index) {
                                return OpenContainer(
                                    transitionDuration: const Duration(milliseconds: 700),
                                    middleColor: Colors.grey.shade800,
                                    openColor: Colors.grey.shade900,
                                    closedColor: Colors.transparent.withOpacity(index < 10 ? index / 10 : (index % 10) / 10),
                                    transitionType: ContainerTransitionType.fadeThrough,
                                    openBuilder: (BuildContext context, VoidCallback openContainer) {
                                      return ProfilePage(userID: userEventScoreList[index]['id']);
                                    },
                                    closedBuilder: (BuildContext context, VoidCallback openContainer) {
                                      return ListTile(
                                        leading: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(right: 8.0),
                                              child: Text(
                                                userEventScoreList[index]['rank'].toString(),
                                                style: Theme.of(context).textTheme.headline5,
                                              ),
                                            ),
                                            CircleAvatar(
                                              backgroundImage: NetworkImage(userEventScoreList[index]['avatar'] ?? ''),
                                            ),
                                          ],
                                        ),
                                        title: Text(
                                          userEventScoreList[index]['fullname'],
                                          maxLines: 1,
                                        ),
                                        subtitle: Text(
                                          AppLocalizations.of(context).screenCalendarCategoryList.split(",")[userEventScoreList[index]['category']],
                                          maxLines: 1,
                                        ),
                                        trailing: Text(userEventScoreList[index]['score'].toString()),
                                        onTap: openContainer,
                                      );
                                    });
                              },
                            ),
                          ),
                  )
          ],
        ),
      ),
    );
  }
}
