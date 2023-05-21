import 'dart:async';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:pacha/constants.dart';
import 'package:pacha/globals.dart';
import 'package:pacha/models/challenge_details.dart';
import 'package:pacha/pacha_api.dart';

class ScreenChallengeSelection extends StatefulWidget {
  const ScreenChallengeSelection({Key? key}) : super(key: key);
  @override
  _ChallengeSelection createState() => _ChallengeSelection();
}

enum Status { none, running, done, error }

class _ChallengeSelection extends State<ScreenChallengeSelection> {
  Status status = Status.none;
  List<dynamic> listItems = [];
  _loadChallengeList() {
    status = Status.running;
    PaChaAPI().challengeList().then((response) {
      Map<String, dynamic> json = (response as Map)['json'];
      setState(() {
        List list = (json['current'] as List);
        if (list.isNotEmpty) {
          listItems.add(AppLocalizations.of(context).screenChallengeSelectionNow);
          listItems.addAll(list);
        }
        list = (json['coming'] as List);
        if (list.isNotEmpty) {
          listItems.add(AppLocalizations.of(context).screenChallengeSelectionIncoming);
          listItems.addAll(list);
        }
        list = (json['past'] as List);
        if (list.isNotEmpty) {
          listItems.add(AppLocalizations.of(context).screenChallengeSelectionPast);
          listItems.addAll(list);
        }
        status = Status.done;
      });
    }).onError((error, stackTrace) {
      setState(() {
        listItems.clear();
        status = Status.error;
      });
    });
  }

  _ChallengeSelection() {
    _loadChallengeList();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              leading: Globals.challenge == null
                  ? null
                  : IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Constants().appBarBackIcon),
              centerTitle: true,
              title: Text(Globals.challenge == null
                  ? AppLocalizations.of(context).screenChallengeSelectionTitleSelect
                  : AppLocalizations.of(context).screenChallengeSelectionTitleSwitch),
            ),
            backgroundColor: Colors.black,
            body: LayoutBuilder(builder: (BuildContext context, BoxConstraints viewportConstraints) {
              if (status == Status.done) {
                return ListView.builder(
                  itemCount: listItems.length,
                  itemBuilder: (context, index) {
                    return listItems[index] is String
                        ? Padding(
                            padding: EdgeInsets.only(top: Constants().padding * 2),
                            child: Text(
                              listItems[index],
                              style: Theme.of(context).textTheme.headline3,
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.only(top: Constants().padding / 2, bottom: index == listItems.length - 1 ? Constants().padding * 2 : 0),
                            child: GestureDetector(
                              onTap: () {
                                PaChaAPI().challengeGet(listItems[index]['id']).then((response) {
                                  Map<String, dynamic> json = (response as Map)['json'];
                                  Globals.challenge = ChallengeDetails.fromJson(json);
                                  Navigator.of(context).pushReplacementNamed('/main');
                                }).onError((error, stackTrace) {
                                  int code = (error as Map)['code'];
                                  if (code == -1) {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).apiErrorUnableToConnect)));
                                  } else if (code == 401) {}
                                }).whenComplete(() => setState(() {}));
                              },
                              child: SizedBox(
                                  width: double.infinity,
                                  child: Image.network(
                                    listItems[index]['banner_image'],
                                    fit: BoxFit.fill,
                                  )),
                            ),
                          );
                  },
                );
              } else if (status == Status.error) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(AppLocalizations.of(context).screenChallengeSelectionLoseInternetConnection,
                          maxLines: 2, textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline6),
                      Padding(
                          padding: EdgeInsets.all(Constants().padding),
                          child: IconButton(
                            iconSize: Constants().padding * 4,
                            icon: const Icon(
                              Icons.refresh_outlined,
                            ),
                            onPressed: () {
                              setState(() {
                                status = Status.running;
                              });
                              _loadChallengeList();
                            },
                          )),
                    ],
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            })));
  }
}
