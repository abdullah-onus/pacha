import 'package:flutter/material.dart';
import 'package:pacha/screens/scores/advanced_score.dart';
import 'package:pacha/screens/scores/daily_score.dart';
import 'package:pacha/screens/scores/events_score.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ScreenScore extends StatefulWidget {
  const ScreenScore({Key? key}) : super(key: key);
  @override
  _ScreenScoreState createState() => _ScreenScoreState();
}

class _ScreenScoreState extends State<ScreenScore> with SingleTickerProviderStateMixin {
  late TabController _controller;
  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 3, vsync: this, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Column(
        children: <Widget>[
          TabBar(
            onTap: (value) {
              setState(() {});
            },
            controller: _controller,
            tabs: <Widget>[
              Tab(
                text: AppLocalizations.of(context).screenScoreTabBarFirstTabText,
              ),
              Tab(
                text: AppLocalizations.of(context).screenScoreTabBarSecondTabText,
              ),
              Tab(
                text: AppLocalizations.of(context).screenScoreTabBarThirdTabText,
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _controller,
              children: const [
                DailyScore(),
                EventScore(),
                AdvancedScore(),
              ],
            ),
          )
        ],
      )),
    );
  }
}
