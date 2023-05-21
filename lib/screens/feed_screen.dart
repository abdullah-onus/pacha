import 'dart:core';
import 'package:flutter/material.dart';
import 'package:pacha/pacha_api.dart';
import 'package:pacha/widgets/feed_plate.dart';

class ScreenFeed extends StatefulWidget {
  const ScreenFeed({Key? key}) : super(key: key);
  @override
  _ScreenFeedState createState() => _ScreenFeedState();
}

enum Status { none, running, done, error }

class _ScreenFeedState extends State<ScreenFeed> with AutomaticKeepAliveClientMixin<ScreenFeed> {
  @override
  bool get wantKeepAlive => true;
  Status status = Status.none;
  List<dynamic> feedList = [];
  List<dynamic> newList = [];
  bool loadingMore = false;
  final ScrollController feedScrollController = ScrollController();
  loadMore() async {
    PaChaAPI().challengeFeed(timestamp: feedList[feedList.length - 1]['created_at'], direction: "d", limit: 15).then((response) {
      Map<String, dynamic> json = (response as Map)['json'];
      List<dynamic> loadMoreData = [];
      setState(() {
        loadingMore = true;
        loadMoreData.addAll((json['feed'] as List));
        feedList = [...feedList, ...loadMoreData];
      });
    }).whenComplete(() {
      loadingMore = false;
    }).onError((error, stackTrace) {});
  }

  _getFeed({String? language, String? timestamp, int? limit, String? direction}) {
    status = Status.running;
    PaChaAPI()
        .challengeFeed(language: language, timestamp: timestamp, limit: limit, direction: direction)
        .then((response) {
          Map<String, dynamic> json = (response as Map)['json'];
          setState(() {
            feedList.addAll((json['feed'] as List));
            status = Status.done;
          });
        })
        .whenComplete(() => null)
        .onError((error, stackTrace) {
          feedList.clear();
          status = Status.error;
        });
  }

  @override
  void initState() {
    super.initState();
    _getFeed(limit: 30);
    feedScrollController.addListener(() {
      if (feedScrollController.position.pixels >= feedScrollController.position.maxScrollExtent && !loadingMore) {
        loadMore();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    feedScrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: () async {
        PaChaAPI()
            .challengeFeed(timestamp: feedList[0]['created_at'], direction: "u")
            .then((response) {
              Map<String, dynamic> json = (response as Map)['json'];
              setState(() {
                newList.addAll((json['feed'] as List));
                feedList = [...newList, ...feedList];
              });
            })
            .whenComplete(() {})
            .onError((error, stackTrace) {});
      },
      child: SafeArea(
        child: Scaffold(
          body: status == Status.running
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Stack(
                  children: [
                    ListView.builder(
                      controller: feedScrollController,
                      itemCount: feedList.length,
                      itemBuilder: (BuildContext context, index) {
                        return SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: FeedPlate(
                              id: feedList[index]['id'],
                              type: feedList[index]['type'],
                              showUser: feedList[index]['show_user'],
                              showAvatar: feedList[index]['show_avatar'],
                              showTitle: feedList[index]['show_title'],
                              showSubtitle: feedList[index]['show_subtitle'],
                              showBody: feedList[index]['show_body'],
                              body: feedList[index]['body'],
                              showDescription: feedList[index]['show_description'],
                              description: feedList[index]['description'],
                              showCreatedAt: feedList[index]['show_created_at'],
                              createdAt: feedList[index]['created_at'],
                              userId: feedList[index]['user_id'],
                              userFullname: feedList[index]['user_fullname'],
                              userCategory: feedList[index]['user_category'],
                              title: feedList[index]['title'],
                              subtitle: feedList[index]['subtitle'],
                              avatar: feedList[index]['avatar'],
                              userAvatar: feedList[index]['user_avatar'],
                            ));
                      },
                    ),
                    if (loadingMore) ...[
                      const Align(
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                            width: double.maxFinite,
                            height: 80,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ))
                    ]
                  ],
                ),
        ),
      ),
    );
  }
}
