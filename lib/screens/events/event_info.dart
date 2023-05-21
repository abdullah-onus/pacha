import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';
import 'package:pacha/models/calendar_event.dart';
import 'package:pacha/settings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../constants.dart';

class EventInfo extends StatefulWidget {
  const EventInfo({Key? key, required this.event}) : super(key: key);
  final CalendarEvent event;
  @override
  _EventInfoState createState() => _EventInfoState();
}

class _EventInfoState extends State<EventInfo> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close),
          ),
          title: MarkdownBody(
            data: widget.event.title,
          ),
        ),
        body: buildPhysicalEventDetails(),
      ),
    );
  }

  buildPhysicalEventDetails() {
    return ListView(
      children: [
        //StartDateTextField
        Padding(
          padding: EdgeInsets.only(left: Constants().padding, bottom: Constants().padding, right: Constants().padding),
          child: Focus(
            child: TextField(
                readOnly: true,
                decoration: InputDecoration(
                    hintText: DateFormat.yMMMMd(Settings().getLanguage).add_Hm().format(widget.event.startDate), suffixIcon: const Icon(Icons.calendar_today)),
                onTap: () {}),
          ),
        ),
        //EndDateTextField
        Padding(
          padding: EdgeInsets.only(left: Constants().padding, bottom: Constants().padding, right: Constants().padding),
          child: TextField(
              readOnly: true,
              decoration: InputDecoration(
                hintText: DateFormat.yMMMMd(Settings().getLanguage).add_Hm().format(widget.event.endDate),
                suffixIcon: const Icon(Icons.calendar_today),
              ),
              onTap: () {}),
        ),
        Padding(
          padding: EdgeInsets.only(left: Constants().padding, bottom: Constants().padding, right: Constants().padding),
          child: TextFormField(
            readOnly: true,
            decoration: InputDecoration(
              suffixIcon: const Icon(Icons.location_on),
              hintText: widget.event.location,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: Constants().padding, bottom: Constants().padding, right: Constants().padding),
          child: TextField(
            readOnly: true,
            maxLines: 4,
            onTap: () {},
            decoration: InputDecoration(
                alignLabelWithHint: true,
                hintText: Text(
                  widget.event.description,
                ).data),
          ),
        ),
        Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: Constants().padding, bottom: Constants().padding, right: Constants().padding),
              child: TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  alignLabelWithHint: true,
                  hintText: DateFormat.yMMMMd(Settings().getLanguage).add_Hm().format(widget.event.checkInStart),
                  suffixIcon: const Icon(Icons.calendar_today),
                ),
                onTap: () {},
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: Constants().padding, bottom: Constants().padding, right: Constants().padding),
              child: TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  hintText: DateFormat.yMMMMd(Settings().getLanguage).add_Hm().format(widget.event.checkInEnd),
                  alignLabelWithHint: true,
                  suffixIcon: const Icon(Icons.calendar_today),
                ),
                onTap: () {},
              ),
            ),
          ],
        ),
        Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: Constants().padding, bottom: Constants().padding, right: Constants().padding),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).screenCalendarRewardIncentives,
                  border: const OutlineInputBorder(),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: Constants().padding, right: Constants().padding),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Checkbox(value: widget.event.rewardRSVP, onChanged: (bool? value) {}),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 3.4,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    AppLocalizations.of(context).screenCalendarRewardRSVP,
                                    maxLines: 1,
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(value: widget.event.rewardCheckIn, onChanged: (bool? value) {}),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 3,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    AppLocalizations.of(context).screenCalendarRewardCheckin,
                                    maxLines: 1,
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(
                                value: widget.event.rewardtimelyCheckIn,
                                onChanged: (bool? time) {},
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 1.7,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    AppLocalizations.of(context).screenCalendarRewardIncertiveTimelyCheckin,
                                    maxLines: 1,
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(left: Constants().padding, bottom: Constants().padding, right: Constants().padding),
          child: TextField(textInputAction: TextInputAction.next, readOnly: true, onTap: () {}, decoration: InputDecoration(hintText: widget.event.voters)),
        ),
        Padding(
          padding: EdgeInsets.only(left: Constants().padding, bottom: Constants().padding, right: Constants().padding),
          child: TextFormField(
            readOnly: true,
            onTap: () {},
            decoration: InputDecoration(hintText: widget.event.votingMethod),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: Constants().padding, bottom: Constants().padding, right: Constants().padding),
          child: TextFormField(
            readOnly: true,
            onTap: () {},
            decoration: InputDecoration(hintText: widget.event.maxParticipations),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: Constants().padding, bottom: Constants().padding, right: Constants().padding),
          child: TextField(textInputAction: TextInputAction.next, readOnly: true, onTap: () {}, decoration: InputDecoration(hintText: widget.event.guestList)),
        ),
        Padding(
          padding: EdgeInsets.only(
            bottom: Constants().padding,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(style: TextButton.styleFrom(), onPressed: () {}, child: const Text("I will join")),
              ElevatedButton(
                style: TextButton.styleFrom(),
                onPressed: () {},
                child: const Text("I will join late"),
              ),
            ],
          ),
        )
      ],
    );
  }
}
