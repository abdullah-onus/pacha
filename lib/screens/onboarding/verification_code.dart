import 'dart:async';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:pacha/models/verification_code_arguments.dart';
import 'package:pacha/constants.dart';
import 'package:pacha/pacha_api.dart';

class ScreenVerificationCode extends StatefulWidget {
  const ScreenVerificationCode({Key? key}) : super(key: key);
  @override
  _ScreenVerificationCodeState createState() => _ScreenVerificationCodeState();
}

class _ScreenVerificationCodeState extends State<ScreenVerificationCode> {
  final textEditingControllerVerificationCode = TextEditingController();
  bool isCodeFulfilled = false;
  int timerValue = Constants().resendTime;
  bool isTimerVisible = true;
  bool timerFinished = false;
  bool canResendCode = false;
  final Stream<int> periodicStream = Stream.periodic(const Duration(milliseconds: 1000), (i) => i);
  int previousStreamValue = 0;
  bool isConnectingToAPI = false;
  bool isVerificationDisabled = false;
  int userID = 0;
  void verification(BuildContext context) async {
    setState(() {
      isConnectingToAPI = true;
      isVerificationDisabled = true;
    });
    PaChaAPI().signUpVerificationCheck(userID, textEditingControllerVerificationCode.text).then((response) {
      if (response['code'] == 200) {
        Navigator.of(context).pushReplacementNamed('/onboarding/login');
      }
    }).whenComplete(() {
      setState(() {
        isConnectingToAPI = false;
      });
    }).onError((error, stackTrace) {
      setState(() {
        isConnectingToAPI = false;
      });
    });
  }

  void verificationNew(BuildContext context) async {
    setState(() {
      isConnectingToAPI = true;
      isVerificationDisabled = true;
    });
    PaChaAPI().signUpVerificationResend(userID).then((response) {
      if (response['code'] == 200) {}
    }).whenComplete(() {
      setState(() {
        isConnectingToAPI = false;
      });
    }).onError((error, stackTrace) {
      setState(() {
        isConnectingToAPI = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as VerificationCodeArguments;
    userID = args.userID;
    return SafeArea(
      child: StreamBuilder<Object>(
          stream: periodicStream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data != previousStreamValue) {
                previousStreamValue = snapshot.data!;
                if (!timerFinished) {
                  timerValue--;
                  canResendCode = false;
                  if (timerValue == 0) {
                    canResendCode = true;
                    isTimerVisible = false;
                    timerFinished = true;
                  }
                }
              }
            }
            return Scaffold(
                appBar: AppBar(
                  title: Text(AppLocalizations.of(context).appName),
                ),
                body: LayoutBuilder(builder: (BuildContext context, BoxConstraints viewportConstraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: viewportConstraints.maxHeight,
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: Constants().padding, bottom: Constants().padding, right: Constants().padding),
                        child: IgnorePointer(
                          ignoring: isConnectingToAPI,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(bottom: Constants().padding),
                                  child: Text(
                                    AppLocalizations.of(context).screenVerificationCodeTextSubtitle,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.headline2,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: Constants().padding),
                                  child: Text(
                                    args.email!.isNotEmpty
                                        ? AppLocalizations.of(context).screenVerificationCodeTextDescriptionEmail(args.email!)
                                        : AppLocalizations.of(context).screenVerificationCodeTextDescriptionTextMessage(args.phone!),
                                    style: Theme.of(context).textTheme.bodyText1,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: Constants().padding),
                                  child: TextField(
                                    controller: textEditingControllerVerificationCode,
                                    onChanged: (value) {
                                      setState(() {
                                        isCodeFulfilled = textEditingControllerVerificationCode.text.length == 6;
                                      });
                                    },
                                    onSubmitted: (_) {
                                      verification(context);
                                    },
                                    style: const TextStyle(
                                      letterSpacing: 5,
                                    ),
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    autofocus: true,
                                    maxLength: 6,
                                    decoration: InputDecoration(
                                      labelText: AppLocalizations.of(context).screenVerificationCodeTextFieldVerificationCode,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: Constants().padding),
                                  child: ElevatedButton(
                                    onPressed: isCodeFulfilled
                                        ? () {
                                            verification(context);
                                          }
                                        : null,
                                    child: Text(
                                      (AppLocalizations.of(context).screenVerificationCodeElevetedButtonText),
                                    ),
                                  ),
                                ),
                                ...(isConnectingToAPI
                                    ? [
                                        const Padding(
                                            padding: EdgeInsets.only(bottom: 12),
                                            child: LinearProgressIndicator(
                                              value: null,
                                              semanticsLabel: 'Linear progress indicator',
                                            ))
                                      ]
                                    : []),
                                Align(
                                  alignment: Alignment.center,
                                  child: TextButton(
                                    onPressed: canResendCode
                                        ? () {
                                            timerValue = 60;
                                            timerFinished = false;
                                            isTimerVisible = true;
                                            verificationNew(context);
                                          }
                                        : null,
                                    child: Text(
                                      canResendCode
                                          ? AppLocalizations.of(context).screenVerificationCodeTextButtonResendCode
                                          : AppLocalizations.of(context).screenVerificationMethodTimerText(timerValue),
                                    ),
                                  ),
                                ),
                              ]),
                        ),
                      ),
                    ),
                  );
                }));
          }),
    );
  }
}
