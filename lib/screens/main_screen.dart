import 'package:flutter/material.dart';
import 'package:pacha/constants.dart';
import 'package:pacha/globals.dart';
import 'package:pacha/pacha_api.dart';
import 'package:pacha/screens/calendar_screen.dart';
import 'package:pacha/screens/chat/chat_screen.dart';
import 'package:pacha/screens/challenge_home.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pacha/main.dart';
import 'package:pacha/screens/feed_screen.dart';
import 'package:pacha/screens/scores/screen_score.dart';
import 'package:url_launcher/url_launcher.dart';

class ScreenMain extends StatefulWidget {
  const ScreenMain({Key? key}) : super(key: key);
  @override
  _ScreenMainState createState() => _ScreenMainState();
}

class _ScreenMainState extends State<ScreenMain> {
  //bool isConnectingToAPI = false;
  int _currentIndex = 0;
  List<Widget> _pages = [];
  PageController _pageController = PageController();
  @override
  void initState() {
    _pages = [
      const ChallengeHome(),
      const ScreenFeed(),
      const ScreenCalendar(),
      const ScreenScore(),
      const ScreenChat()
    ];
    _pageController = PageController(initialPage: _currentIndex);
    super.initState();
  }
/* 
  void logout(BuildContext context) {
    PaChaAPI()
        .userLogout()
        .then((response) {
          setState(() {
            isConnectingToAPI = true;
          });
        })
        .whenComplete(() => isConnectingToAPI = false)
        .onError((error, stackTrace) {
          setState(() {
            isConnectingToAPI = false;
          });
        });
  } */

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List navRoutes = [];
    MyApp.routes.forEach(
      (k, v) => navRoutes.add(
        PopupMenuItem<String>(
          value: k,
          child: Text(k),
        ),
      ),
    );
    return SafeArea(
        child: DefaultTabController(
            length: 5,
            child: Scaffold(
              appBar: AppBar(
                  leading: Padding(
                      padding: EdgeInsets.only(left: Constants().padding),
                      child: Image.asset(
                        'assets/logo-appbar.png',
                        color: Color(Globals.challenge!.appbarLogoColor ?? 0),
                      )),
                  flexibleSpace: FlexibleSpaceBar(
                      background: Image.network(
                    Globals.challenge!.appbarImage ?? '',
                    fit: BoxFit.cover,
                  )),
                  actions: [
                    PopupMenuButton<String>(
                        icon: Icon(Icons.menu,
                            color:
                                Color(Globals.challenge!.appbarMenuColor ?? 0)),
                        tooltip: AppLocalizations.of(context)
                            .screenMainPopUpButtonToolTipText,
                        onSelected: (item) =>
                            Navigator.of(context).pushNamed(item),
                        itemBuilder: (contextX) => [
                              PopupMenuItem<String>(
                                value: '/challenges',
                                child: Text(AppLocalizations.of(contextX)
                                    .screenMainPopUpButtonFirstItemText),
                              ),
                              const PopupMenuDivider(),
                              PopupMenuItem<String>(
                                value: '/profile/details',
                                child: Text(AppLocalizations.of(contextX)
                                    .screenMainPopUpButtonSecondItemText),
                              ),
                              const PopupMenuDivider(),
                              ...navRoutes,
                              const PopupMenuDivider(),
                              PopupMenuItem<String>(
                                onTap: () {
                                  launch(AppLocalizations.of(contextX)
                                      .appUrlTermsOfService);
                                },
                                child: Text(
                                  AppLocalizations.of(contextX)
                                      .screenSettingsListLegalTermsOfUseTitle,
                                ),
                              ),
                              const PopupMenuDivider(),
                              PopupMenuItem<String>(
                                onTap: () {
                                  launch(AppLocalizations.of(contextX)
                                      .appUrlPrivacyPolicy);
                                },
                                child: Text(
                                  AppLocalizations.of(contextX)
                                      .screenSettingsListLegalPrivacyPolicyTitle,
                                ),
                              ),
                              const PopupMenuDivider(),
                              PopupMenuItem<String>(
                                value: '/onboarding/login',
                                onTap: () {
                                  // logout(context);
                                },
                                child: Text(
                                  AppLocalizations.of(contextX)
                                      .screenSettingsListLogoutButton,
                                ),
                              ),
                            ])
                  ]),
              resizeToAvoidBottomInset: false,
              bottomNavigationBar: SizedBox(
                  height: AppBar().preferredSize.height,
                  child: BottomNavigationBar(
                    selectedItemColor: Colors.white,
                    unselectedItemColor: Colors.grey,
                    type: BottomNavigationBarType.shifting,
                    currentIndex: _currentIndex,
                    items: [
                      BottomNavigationBarItem(
                        backgroundColor: Colors.black,
                        icon: const Icon(Icons.home),
                        label: AppLocalizations.of(context)
                            .screenMainBottomNavigationBarItemHome,
                      ),
                      BottomNavigationBarItem(
                        backgroundColor: Colors.black,
                        icon: const Icon(Icons.notifications),
                        label: AppLocalizations.of(context)
                            .screenMainBottomNavigationBarItemFeed,
                      ),
                      BottomNavigationBarItem(
                        backgroundColor: Colors.black,
                        icon: const Icon(Icons.calendar_today),
                        label: AppLocalizations.of(context)
                            .screenMainBottomNavigationBarItemCalendar,
                      ),
                      BottomNavigationBarItem(
                        backgroundColor: Colors.black,
                        icon: const Icon(Icons.auto_graph),
                        label: AppLocalizations.of(context)
                            .screenMainBottomNavigationBarItemScores,
                      ),
                      BottomNavigationBarItem(
                        backgroundColor: Colors.black,
                        icon: const Icon(Icons.chat),
                        label: AppLocalizations.of(context)
                            .screenMainBottomNavigationBarItemChat,
                      ),
                    ],
                    onTap: (int index) {
                      setState(() {
                        _currentIndex = index;
                        _pageController.jumpToPage(_currentIndex);
                      });
                    },
                  )),
              body: IgnorePointer(
                // ignoring: isConnectingToAPI,
                child: PageView(
                  controller: _pageController,
                  children: _pages,
                  physics: const NeverScrollableScrollPhysics(),
                ),
              ),
            )));
  }
}
