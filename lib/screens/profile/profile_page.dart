import 'package:flutter/material.dart';
import 'package:pacha/constants.dart';
import 'package:pacha/globals.dart';
import 'package:pacha/models/user_details.dart';
import 'package:pacha/pacha_api.dart';
import 'package:pacha/screens/chat/chat_screen_user.dart';
import 'package:pacha/widgets/carousel_image/carousel_slider.dart';
import 'package:pacha/widgets/slide_up.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfilePage extends StatefulWidget {
  final int userID;
  const ProfilePage({Key? key, required this.userID}) : super(key: key);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

enum Status { none, running, done, error }

class _ProfilePageState extends State<ProfilePage> {
  Status status = Status.none;
  UserDetails? user = UserDetails();
  final double _panelHeightClosed = 110.0;
  final CarouselController _controller = CarouselController();
  int _current = 0;
  _userDetails(int id) async {
    status = Status.running;
    PaChaAPI().userGet(id).then((response) {
      Map<String, dynamic> json = (response as Map)['json'];
      setState(() {
        user!.id = json['id'];
        user!.email = json['email'];
        user!.emailVerifiedAt = json['email_verified_at'];
        user!.phone = json['phone'];
        user!.phoneVerifiedAt = json['phone_verified_at'];
        user!.dateOfBirth = json['date_of_birth'];
        user!.challenge = json['challenge'];
        user!.fullname = json['fullname'];
        user!.category = json['category'];
        user!.bio = json['bio'];
        user!.instagram = json['instagram'];
        user!.twitter = json['twitter'];
        user!.facebook = json['facebook'];
        user!.website = json['website'];
        user!.status = json['status'];
        user!.language = json['language'];
        user!.role = json['role'];
        user!.createdAt = json['created_at'];
        user!.avatar = json['avatar'];
        if (json['photos'] != null) {
          user!.photos = <Photos>[];
          json['photos'].forEach((v) {
            user!.photos!.add(Photos.fromJson(v));
          });
        }
        status = Status.done;
      });
    }).onError((error, stackTrace) {
      setState(() {
        status = Status.error;
      });
    });
  }

  @override
  void initState() {
    _userDetails(widget.userID);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: status == Status.running
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Scaffold(
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.clear_outlined),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                actions: [
                  user!.id == Globals.user!.id
                      ? IconButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                              '/profile/edit',
                            );
                          },
                          icon: const Icon(Icons.create_outlined),
                        )
                      : IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (builder) => ScreenChatUser(
                                          id: user!.id,
                                          avatar: user!.avatar,
                                          fullname: user!.fullname,
                                        )));
                          },
                          icon: const Icon(Icons.markunread_outlined),
                        ),
                ],
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              body: SlidingUpPanel(
                backdropEnabled: true,
                backdropOpacity: 0.75,
                maxHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom -
                    AppBar().preferredSize.height,
                minHeight: _panelHeightClosed,
                body: Stack(children: <Widget>[
                  user!.photos != null
                      ? CarouselSlider(
                          carouselController: _controller,
                          items: user!.photos!
                              .map((item) => Center(
                                      child: Image.network(
                                    item.url ?? '',
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                    repeat: ImageRepeat.noRepeat,
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return const Center(child: CircularProgressIndicator());
                                    },
                                    errorBuilder: (context, exception, stackTrace) {
                                      return Center(child: Image.asset('assets/logo.png'));
                                    },
                                  )))
                              .toList(),
                          options: CarouselOptions(
                            enlargeCenterPage: true,
                            initialPage: 0,
                            aspectRatio: 16 / 9,
                            onPageChanged: (index, reason) {
                              setState(() {
                                _current = index;
                              });
                            },
                            pageSnapping: true,
                            height: double.infinity,
                            viewportFraction: 1,
                            enableInfiniteScroll: false,
                            autoPlay: false,
                          ),
                        )
                      : Image.asset('assets/logo.png'),
                  user!.photos != null && user!.photos!.length > 1
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: user!.photos!.asMap().entries.map((entry) {
                            return GestureDetector(
                              onTap: () => _controller.animateToPage(entry.key),
                              child: Container(
                                width: 12.0,
                                height: 12.0,
                                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _current == entry.key ? Theme.of(context).indicatorColor : Theme.of(context).disabledColor,
                                ),
                              ),
                            );
                          }).toList(),
                        )
                      : Container()
                ]),
                panelBuilder: (sc) => _panel(sc),
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
              )),
    );
  }

  Widget _panel(ScrollController sc) {
    Widget socialMediaIcon(String socialMedia, String baseUrl, String address) {
      return IconButton(
          icon: Image.asset(
            "assets/icons/$socialMedia.png",
            color: address.isEmpty ? Theme.of(context).disabledColor : Theme.of(context).colorScheme.primary,
          ),
          iconSize: 35,
          onPressed: address.isEmpty
              ? null
              : () {
                  launch(baseUrl + address);
                });
    }

    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Padding(
          padding: EdgeInsets.only(bottom: Constants().padding),
          child: ListView(
            controller: sc,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: Constants().padding, bottom: Constants().padding / 1.5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 30,
                      height: 5,
                      decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.all(Radius.circular(Constants().padding))),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: Constants().padding / 4,
                  left: Constants().padding,
                  right: Constants().padding,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(user!.fullname ?? '', style: Theme.of(context).textTheme.headline4),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: Constants().padding,
                  left: Constants().padding,
                  right: Constants().padding,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(AppLocalizations.of(context).screenCalendarCategoryList.split(",").elementAt(user!.category!),
                        style: Theme.of(context).textTheme.headline6),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: Constants().padding * 2),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        socialMediaIcon("facebook", AppLocalizations.of(context).appUrlFacebook, user!.facebook ?? ''),
                        socialMediaIcon("instagram", AppLocalizations.of(context).appUrlInstagram, user!.instagram ?? ''),
                        socialMediaIcon("twitter", AppLocalizations.of(context).appUrlTwitter, user!.twitter ?? ''),
                        socialMediaIcon("website", '', user!.website ?? ''),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: Constants().padding, right: Constants().padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      user!.bio ?? '',
                      softWrap: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
