import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pacha/globals.dart';
import 'package:pacha/pacha_api.dart';
import 'package:pacha/screens/profile/profile_page.dart';
import 'package:pacha/settings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DailyScore extends StatefulWidget {
  const DailyScore({Key? key}) : super(key: key);
  @override
  State<DailyScore> createState() => _DailyScoreState();
}

enum Status { none, running, done, error }

class _DailyScoreState extends State<DailyScore> with AutomaticKeepAliveClientMixin<DailyScore> {
  @override
  bool get wantKeepAlive => true;
  int requestCount = 0;
  Status status = Status.none;
  int clickTime = 0;
  DateTime startDate = DateTime.parse(Globals.challenge!.startDate!);
  DateTime endDate = DateTime.parse(Globals.challenge!.endDate!);
  DateTime initialDate = DateTime.parse(Globals.challenge!.startDate!);
  List<dynamic> userDailyScoreList = [];
  _getDailyScoreBoard({String? startDate, String? endDate, int? event, int? category}) {
    status = Status.running;
    requestCount++;
    PaChaAPI().userScoreList(challengeId: Globals.challenge!.id!, category: category, startDate: startDate, endDate: endDate, event: event).then((response) {
      requestCount--;
      if (requestCount == 0) {
        Map<String, dynamic> json = (response)['json'];
        setState(() {
          userDailyScoreList.addAll((json['results'] as List));
          status = Status.done;
        });
      }
    }).onError((error, stackTrace) {
      setState(() {
        userDailyScoreList.clear();
        status = Status.error;
      });
    });
  }

  @override
  void initState() {
    _getDailyScoreBoard();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    String time = DateFormat.yMMMMd(Settings().getLanguage).format(initialDate.subtract(const Duration(days: 1)).toLocal());
    return Scaffold(
        body: Column(children: [
      ListTile(
        leading: IconButton(
            onPressed: () {
              setState(() {
                if (initialDate.isAfter(startDate)) {
                  initialDate = initialDate.subtract(const Duration(days: 1));
                  clickTime--;
                  userDailyScoreList.clear();
                  if (clickTime == 0) {
                    userDailyScoreList.clear();
                    _getDailyScoreBoard();
                  } else {
                    userDailyScoreList.clear();
                    _getDailyScoreBoard(
                        startDate: initialDate.subtract(const Duration(days: 1)).toString().replaceAll(' ', 'T'),
                        endDate: initialDate.toString().replaceAll(' ', 'T'));
                  }
                }
              });
            },
            icon: const Icon(Icons.arrow_back),
            color: Colors.amber),
        title: Center(
          child: Text(
            clickTime != 0 ? time : AppLocalizations.of(context).screenScoreDailyTabOverallText,
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        subtitle: Visibility(
          visible: clickTime != 0,
          child: Center(
            child: Text(
              AppLocalizations.of(context).screenScoreDailyTabDayPlaceHolder + ' ' + (initialDate.difference(startDate).inDays).toString(),
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
        ),
        trailing: IconButton(
          onPressed: () {
            setState(() {
              if (initialDate.isBefore(endDate)) {
                initialDate = initialDate.add(const Duration(days: 1));
                userDailyScoreList.clear();
                _getDailyScoreBoard(
                    startDate: initialDate.subtract(const Duration(days: 1)).toString().replaceAll(' ', 'T'),
                    endDate: initialDate.toString().replaceAll(' ', 'T'));
                clickTime++;
              }
            });
          },
          icon: const Icon(Icons.arrow_forward),
          color: Colors.amber,
        ),
      ),
      Expanded(
        child: status == Status.running
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: userDailyScoreList.length,
                itemBuilder: (context, index) {
                  return OpenContainer(
                      transitionDuration: const Duration(milliseconds: 700),
                      middleColor: Colors.grey.shade800,
                      openColor: Colors.grey.shade900,
                      closedColor: Colors.transparent.withOpacity(index < 10 ? index / 10 : (index % 10) / 10),
                      transitionType: ContainerTransitionType.fadeThrough,
                      openBuilder: (BuildContext context, VoidCallback openContainer) {
                        return ProfilePage(userID: userDailyScoreList[index]['id']);
                      },
                      closedBuilder: (BuildContext context, VoidCallback openContainer) {
                        return ListTile(
                          leading: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Text(
                                  userDailyScoreList[index]['rank'].toString(),
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                              ),
                              CircleAvatar(
                                backgroundImage: NetworkImage(userDailyScoreList[index]['avatar'] ?? ''),
                              ),
                            ],
                          ),
                          title: Text(
                            userDailyScoreList[index]['fullname'],
                            maxLines: 1,
                          ),
                          subtitle: Text(
                            AppLocalizations.of(context).screenCalendarCategoryList.split(",")[userDailyScoreList[index]['category']],
                            maxLines: 1,
                          ),
                          trailing: Text(userDailyScoreList[index]['score'].toString()),
                          onTap: openContainer,
                        );
                      });
                },
              ),
      ),
    ]));
  }
}
