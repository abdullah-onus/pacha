import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:pacha/globals.dart';
import 'package:pacha/pacha_api.dart';
import 'package:pacha/screens/chat/chat_screen_channel.dart';
import 'package:pacha/screens/chat/chat_screen_user.dart';
import 'package:pacha/utilities.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:async';

class ScreenChat extends StatefulWidget {
  const ScreenChat({Key? key}) : super(key: key);
  @override
  _ScreenChatState createState() => _ScreenChatState();
}

enum Status { none, running, done, error }

class _ScreenChatState extends State<ScreenChat> with SingleTickerProviderStateMixin {
  late TabController _controller;
  Status status = Status.none;
  List<dynamic> listItems = [];
  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this, initialIndex: 0);
  }

  _userList({String? name, int? category}) {
    status = Status.running;
    PaChaAPI().userList(challenge: Globals.challenge!.id!, name: name, category: category).then((response) {
      Map<String, dynamic> json = (response as Map)['json'];
      setState(() {
        listItems.addAll((json['users'] as List));
        status = Status.done;
      });
    }).onError((error, stackTrace) {
      setState(() {
        listItems.clear();
        status = Status.error;
      });
    });
  }

  _ScreenChatState() {
    _userList();
  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: Stream.periodic(const Duration(milliseconds: 1000), (i) => i),
        builder: (context, snapshot) {
          return SafeArea(
            child: Scaffold(
                body: Column(
              children: <Widget>[
                TabBar(
                  controller: _controller,
                  tabs: <Widget>[
                    Tab(
                      text: AppLocalizations.of(context).screenChatTabDirectMessages,
                    ),
                    Tab(
                      text: AppLocalizations.of(context).screenChatTabChannels,
                    ),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _controller,
                    children: <Widget>[
                      status == Status.running
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : ListView.builder(
                              itemCount: listItems.length,
                              itemBuilder: (context, index) {
                                return OpenContainer(
                                    transitionDuration: const Duration(milliseconds: 700),
                                    middleColor: Colors.grey.shade800,
                                    openColor: Colors.grey.shade900,
                                    closedColor: Colors.transparent.withOpacity(index < 10 ? index / 10 : (index % 10) / 10),
                                    transitionType: ContainerTransitionType.fadeThrough,
                                    openBuilder: (BuildContext context, VoidCallback openContainer) {
                                      return ScreenChatUser(
                                        id: listItems[index]['id'],
                                        avatar: listItems[index]['avatar'],
                                        fullname: listItems[index]['fullname'],
                                      );
                                    },
                                    closedBuilder: (BuildContext context, VoidCallback openContainer) {
                                      return Container(
                                        color: (index % 2 == 0) ? Colors.grey.shade700 : Colors.grey.shade800,
                                        child: ListTile(
                                          leading: CircleAvatar(
                                              radius: 25,
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(50.0),
                                                child: Image.network(
                                                  listItems[index]['avatar'],
                                                ),
                                              )),
                                          title: Text(
                                            listItems[index]['fullname'],
                                            maxLines: 1,
                                          ),
                                          subtitle: Text(
                                            AppLocalizations.of(context).screenCalendarCategoryList.split(",")[listItems[index]['category']],
                                            maxLines: 1,
                                          ),
                                          trailing: Text(Utilities().readableTimestamp('2022-01-02 12:46:${index}2.147', context)),
                                          onTap: openContainer,
                                        ),
                                      );
                                    });
                              },
                            ),
                      status == Status.running
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : ListView.builder(
                              primary: false,
                              itemCount: 15,
                              itemBuilder: (context, index) {
                                return OpenContainer(
                                    transitionDuration: const Duration(milliseconds: 700),
                                    middleColor: Colors.grey.shade800,
                                    openColor: Colors.grey.shade900,
                                    closedColor: Colors.transparent.withOpacity(index < 10 ? index / 10 : (index % 10) / 10),
                                    transitionType: ContainerTransitionType.fadeThrough,
                                    openBuilder: (BuildContext context, VoidCallback openContainer) {
                                      return const ScreenChatChannel();
                                    },
                                    closedBuilder: (BuildContext context, VoidCallback openContainer) {
                                      return Container(
                                        color: (index % 2 == 0) ? Colors.grey.shade700 : Colors.grey.shade800,
                                        child: ListTile(
                                          title: Text('name $index'),
                                          subtitle: Text('subtitle $index'),
                                          trailing: Text(Utilities().readableTimestamp('2021-12-27 00:40:22.147', context)),
                                          dense: false,
                                          onTap: openContainer,
                                        ),
                                      );
                                    });
                              },
                            ),
                    ],
                  ),
                )
              ],
            )),
          );
        });
  }
}
