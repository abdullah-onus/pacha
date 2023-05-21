import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';
import 'package:pacha/constants.dart';
import 'package:pacha/screens/profile/profile_page.dart';
import 'package:pacha/settings.dart';
import 'package:pacha/theme.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pacha/widgets/feed_image_carousel.dart';
import 'package:pacha/widgets/video_player.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FeedPlate extends StatefulWidget {
  final int? id;
  final String? type;
  final bool? showUser;
  final int? userId;
  final String? userFullname;
  final int? userCategory;
  final String? userAvatar;
  final bool? showAvatar;
  final String? avatar;
  final bool? showTitle;
  final String? title;
  final bool? showSubtitle;
  final String? subtitle;
  final bool? showBody;
  final dynamic body;
  final bool? showDescription;
  final String? description;
  final bool? showCreatedAt;
  final String? createdAt;
  const FeedPlate({
    Key? key,
    this.id,
    this.type,
    this.showUser,
    this.showAvatar,
    this.showTitle,
    this.showSubtitle,
    this.showBody,
    this.body,
    this.showDescription,
    this.description,
    this.showCreatedAt,
    this.createdAt,
    this.userId,
    this.userFullname,
    this.userCategory,
    this.title,
    this.subtitle,
    this.userAvatar,
    this.avatar,
  }) : super(key: key);
  @override
  State<FeedPlate> createState() => _FeedPlateState();
}

class _FeedPlateState extends State<FeedPlate> {
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: nullcheck(),
      child: Container(
        decoration: const BoxDecoration(color: Colors.black, border: Border(bottom: BorderSide(color: Colors.grey, width: 2))),
        child: Padding(
          padding: EdgeInsets.all(Constants().padding),
          child: Column(
            children: [
              Visibility(
                visible: widget.showUser ?? false,
                child: ListTile(
                    leading: widget.showAvatar == false
                        ? null
                        : InkWell(
                            onTap: () async {
                              if (widget.userId != null) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (builder) => ProfilePage(
                                              userID: widget.userId!,
                                            )));
                              } else {
                                null;
                              }
                            },
                            child: CircleAvatar(
                              radius: 35,
                              backgroundImage: NetworkImage(widget.avatar ?? widget.userAvatar ?? ''),
                            ),
                          ),
                    title: Text(widget.userFullname ?? '', style: PachaTheme.get.textTheme.subtitle2),
                    subtitle: Text(AppLocalizations.of(context).screenCalendarCategoryList.split(",").elementAt(widget.userCategory ?? 0),
                        style: PachaTheme.get.textTheme.bodyText2),
                    trailing: IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz_outlined))),
              ),
              Visibility(
                visible: ((widget.showTitle ?? false) || (widget.showSubtitle ?? false)),
                child: ListTile(
                  title:
                      Visibility(visible: widget.showTitle ?? false, child: Center(child: Text(widget.title ?? '', style: PachaTheme.get.textTheme.subtitle2))),
                  subtitle: Visibility(
                      visible: widget.showSubtitle ?? false, child: Center(child: Text(widget.subtitle ?? '', style: PachaTheme.get.textTheme.bodyText2))),
                ),
              ),
              Visibility(
                  visible: widget.showBody ?? false,
                  child: widget.type == 'photo'
                      ? Padding(
                          padding: EdgeInsets.symmetric(vertical: Constants().padding),
                          child: AspectRatio(
                            aspectRatio: jsonDecode(widget.body)['width'] / jsonDecode(widget.body)['height'],
                            child: Image.network(
                              jsonDecode(widget.body)['url'],
                            ),
                          ),
                        )
                      : widget.type == 'video'
                          ? Padding(
                              padding: EdgeInsets.symmetric(vertical: Constants().padding),
                              child: VideoPlayer(url: jsonDecode(widget.body)['url']),
                            )
                          : widget.type == 'album'
                              ? Padding(
                                  padding: EdgeInsets.symmetric(vertical: Constants().padding),
                                  child: FeedImageCarousel(image: jsonDecode(widget.body)),
                                )
                              : widget.type == 'text'
                                  ? Padding(
                                      padding: EdgeInsets.symmetric(vertical: Constants().padding),
                                      child: Center(
                                        child: MarkdownBody(
                                          data: jsonDecode(widget.body)['text'],
                                          shrinkWrap: true,
                                          styleSheet: MarkdownStyleSheet.fromTheme(PachaTheme.get).copyWith(textScaleFactor: 1.5),
                                          onTapLink: (text, url, title) {
                                            launch(url!);
                                          },
                                        ),
                                      ))
                                  : Center(
                                      child: Text("implement " + widget.type!),
                                    )),
              Visibility(
                visible: widget.showDescription ?? false,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: Constants().padding),
                  child: Container(
                      alignment: Alignment.topLeft,
                      child: MarkdownBody(
                        onTapLink: (text, url, title) {
                          launch(url!);
                        },
                        data: widget.description ?? '',
                        styleSheet: MarkdownStyleSheet(
                          tableBody: PachaTheme.get.textTheme.subtitle1,
                        ),
                      )),
                ),
              ),
              Visibility(
                visible: widget.showCreatedAt ?? false,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: Constants().padding / 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        DateFormat.yMMMMd(Settings().getLanguage).add_Hm().format(DateTime.parse(widget.createdAt!)),
                        style: PachaTheme.get.textTheme.caption,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool nullcheck() {
    return (widget.showAvatar ?? false) ||
        (widget.showBody ?? false) ||
        (widget.showCreatedAt ?? false) ||
        (widget.showDescription ?? false) ||
        (widget.showSubtitle ?? false) ||
        (widget.showTitle ?? false) ||
        (widget.showUser ?? false);
  }
}
