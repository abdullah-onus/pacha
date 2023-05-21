import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pacha/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pacha/globals.dart';
import 'package:pacha/pacha_api.dart';
import 'package:pacha/screens/profile/profile_page.dart';
import 'package:pacha/settings.dart';

class AdvancedScore extends StatefulWidget {
  const AdvancedScore({Key? key}) : super(key: key);
  @override
  State<AdvancedScore> createState() => _AdvancedScoreState();
}

enum Status { none, running, done, error }

class _AdvancedScoreState extends State<AdvancedScore> with AutomaticKeepAliveClientMixin<AdvancedScore> {
  @override
  bool get wantKeepAlive => true;
  Status status = Status.none;
  final textEditingControllerDateRangeController = TextEditingController();
  List<dynamic> userAdvancedScoreList = [];
  DateTime startDate = DateTime.parse(Globals.challenge!.startDate!);
  DateTime endDate = DateTime.parse(Globals.challenge!.endDate!);
  DateTime initialDate = DateTime.parse(Globals.challenge!.startDate!);
  late DateTime endDateRange;
  late DateTime startDateRange;
  int? categoryIndex = -1;
  _getAdvancedScoreBoard({String? startDate, String? endDate, int? event, int? category}) {
    status = Status.running;
    PaChaAPI().userScoreList(challengeId: Globals.challenge!.id!, category: category, startDate: startDate, endDate: endDate, event: event).then((response) {
      Map<String, dynamic> json = (response as Map)['json'];
      setState(() {
        userAdvancedScoreList.addAll((json['results'] as List));
        status = Status.done;
      });
    }).onError((error, stackTrace) {
      setState(() {
        userAdvancedScoreList.clear();
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
              child: Focus(
                child: TextField(
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.datetime,
                  readOnly: true,
                  controller: textEditingControllerDateRangeController,
                  decoration: InputDecoration(
                      labelText: AppLocalizations.of(context).screenScoreAdvancedTabDateRangePickerHintText,
                      suffixIcon: textEditingControllerDateRangeController.text.isEmpty
                          ? const Icon(Icons.calendar_today)
                          : IconButton(
                              onPressed: () {
                                textEditingControllerDateRangeController.clear();
                                if (categoryIndex == null) {
                                  setState(() {
                                    userAdvancedScoreList.clear();
                                  });
                                } else {
                                  setState(() {
                                    userAdvancedScoreList.clear();
                                    _getAdvancedScoreBoard(category: categoryIndex);
                                  });
                                }
                              },
                              icon: const Icon(Icons.clear))),
                  onTap: () async {
                    var date = await showDateRangePicker(
                      builder: (context, child) {
                        return Center(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8, maxHeight: MediaQuery.of(context).size.height * 0.8),
                            child: child,
                          ),
                        );
                      },
                      context: context,
                      helpText: AppLocalizations.of(context).screenScoreAdvancedTabDateRangePickerHelpText,
                      firstDate: startDate,
                      lastDate: endDate,
                    );
                    startDateRange = date!.start;
                    endDateRange = date.end;
                    textEditingControllerDateRangeController.text =
                        "${DateFormat.yMd(Settings().getLanguage).format(startDateRange.toLocal())} - ${DateFormat.yMd(Settings().getLanguage).format(endDateRange.toLocal())}";
                    if (categoryIndex != -1) {
                      userAdvancedScoreList.clear();
                      _getAdvancedScoreBoard(
                          category: categoryIndex,
                          startDate: startDateRange.toString().replaceAll(' ', 'T'),
                          endDate: endDateRange.toString().replaceAll(' ', 'T'));
                    } else {
                      _getAdvancedScoreBoard(startDate: startDateRange.toString().replaceAll(' ', 'T'), endDate: endDateRange.toString().replaceAll(' ', 'T'));
                    }
                  },
                ),
              ),
            ),
            DropdownButtonFormField<String>(
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
                  if (textEditingControllerDateRangeController.text.isNotEmpty) {
                    userAdvancedScoreList.clear();
                    _getAdvancedScoreBoard(
                        category: categoryIndex,
                        startDate: startDateRange.toString().replaceAll(' ', 'T'),
                        endDate: endDateRange.toString().replaceAll(' ', 'T'));
                  } else if (value!.isNotEmpty) {
                    userAdvancedScoreList.clear();
                    _getAdvancedScoreBoard(
                      category: categoryIndex,
                    );
                  } else {
                    userAdvancedScoreList.clear();
                  }
                });
              },
            ),
            categoryIndex == -1 && textEditingControllerDateRangeController.text.isEmpty
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
                              itemCount: userAdvancedScoreList.length,
                              itemBuilder: (context, index) {
                                return OpenContainer(
                                    transitionDuration: const Duration(milliseconds: 700),
                                    middleColor: Colors.grey.shade800,
                                    openColor: Colors.grey.shade900,
                                    closedColor: Colors.transparent.withOpacity(index < 10 ? index / 10 : (index % 10) / 10),
                                    transitionType: ContainerTransitionType.fadeThrough,
                                    openBuilder: (BuildContext context, VoidCallback openContainer) {
                                      return ProfilePage(userID: userAdvancedScoreList[index]['id']);
                                    },
                                    closedBuilder: (BuildContext context, VoidCallback openContainer) {
                                      return ListTile(
                                        leading: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(right: 8.0),
                                              child: Text(
                                                userAdvancedScoreList[index]['rank'].toString(),
                                                style: Theme.of(context).textTheme.headline5,
                                              ),
                                            ),
                                            CircleAvatar(
                                              backgroundImage: NetworkImage(userAdvancedScoreList[index]['avatar'] ?? ''),
                                            ),
                                          ],
                                        ),
                                        title: Text(
                                          userAdvancedScoreList[index]['fullname'],
                                          maxLines: 1,
                                        ),
                                        subtitle: Text(
                                          AppLocalizations.of(context).screenCalendarCategoryList.split(",")[userAdvancedScoreList[index]['category']],
                                          maxLines: 1,
                                        ),
                                        trailing: Text(userAdvancedScoreList[index]['score'].toString()),
                                        onTap: openContainer,
                                      );
                                    });
                              },
                            ),
                          ),
                  ),
          ],
        ),
      ),
    );
  }
}
