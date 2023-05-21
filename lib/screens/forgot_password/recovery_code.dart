import 'dart:async';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pacha/models/recovery_code_arguments.dart';
import 'package:pacha/constants.dart';
import 'package:pacha/models/reset_code_arguments.dart';
import 'package:pacha/pacha_api.dart';

class ScreenRecoveryCode extends StatefulWidget {
  const ScreenRecoveryCode({Key? key}) : super(key: key);
  @override
  _ScreenRecoveryCodeState createState() => _ScreenRecoveryCodeState();
}

class _ScreenRecoveryCodeState extends State<ScreenRecoveryCode> {
  final textEditingControllerRecoveryCode = TextEditingController();
  bool isCodeFulfilled = false;
  int timerValue = Constants().resendTime;
  bool isTimerVisible = true;
  bool isInProcess = false;
  bool timerFinished = false;
  bool canResendCode = false;
  final Stream<int> periodicStream = Stream.periodic(const Duration(milliseconds: 1000), (i) => i);
  int previousStreamValue = 0;
  bool isConnectingToAPI = true;
  static int userID = 0;
  void verification(BuildContext context) async {
    setState(() {
      isConnectingToAPI = true;
      isInProcess = true;
    });
    PaChaAPI().passwordVerificationCheck(userID, textEditingControllerRecoveryCode.text).then((response) {
      if (response['code'] == 200) {
        Navigator.of(context).pushReplacementNamed('/forgot-password/reset-password',
            arguments: ResetCodeArguments(
              userID: userID,
              userPasswordVerificationCode: textEditingControllerRecoveryCode.text,
            ));
      }
    }).whenComplete(() {
      setState(() {
        isConnectingToAPI = false;
        isInProcess = false;
      });
    }).onError((error, stackTrace) {
      setState(() {
        isConnectingToAPI = false;
        isInProcess = false;
      });
    });
  }

  void passwordVerificationNew(BuildContext context) async {
    setState(() {
      isConnectingToAPI = true;
    });
    PaChaAPI().signUpVerificationResend(userID).then((response) {
      if (response['code'] == 200) {
        debugPrint('Resending verification code is successful');
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

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as RecoveryCodeArguments;
    userID = args.userID!;
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
                  leading: IconButton(
                    icon: Constants().appBarBackIcon,
                    tooltip: AppLocalizations.of(context).appbarPreviousScreen,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                body: LayoutBuilder(builder: (BuildContext context, BoxConstraints viewportConstraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: viewportConstraints.maxHeight,
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: Constants().padding, bottom: Constants().padding, right: Constants().padding),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: Constants().padding),
                                child: Text(
                                  AppLocalizations.of(context).screenRecoveryCodeTextSubtitleText,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.headline2,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: Constants().padding),
                                child: Text(
                                  AppLocalizations.of(context).screenRecoveryCodeTextDescriptionEmailText(args.email!),
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: Constants().padding),
                                child: TextField(
                                  style: const TextStyle(letterSpacing: 5),
                                  controller: textEditingControllerRecoveryCode,
                                  onChanged: (value) {
                                    setState(() {
                                      isCodeFulfilled = textEditingControllerRecoveryCode.text.length == 6;
                                    });
                                  },
                                  onSubmitted: (_) {
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("...")));
                                  },
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                  textAlign: TextAlign.center,
                                  autofocus: true,
                                  maxLength: 6,
                                  decoration: InputDecoration(
                                    labelText: AppLocalizations.of(context).screenRecoveryCodeTextFieldRecoveryCodeText,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: isConnectingToAPI ? 0 : Constants().padding),
                                child: Row(children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: isInProcess
                                          ? null
                                          : isCodeFulfilled
                                              ? () {
                                                  verification(context);
                                                }
                                              : null,
                                      child: Text(
                                        (AppLocalizations.of(context).screenRecoveryCodeElevetedButtonSearchText),
                                      ),
                                    ),
                                  ),
                                ]),
                              ),
                              ...(isInProcess
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
                                          passwordVerificationNew(context);
                                        }
                                      : null,
                                  child: Text(
                                    canResendCode
                                        ? AppLocalizations.of(context).screenRecoveryCodeTextButtonResendCodeText
                                        : AppLocalizations.of(context).screenRecoveryMethodTimerText(timerValue),
                                  ),
                                ),
                              ),
                            ]),
                      ),
                    ),
                  );
                }));
          }),
    );
  }
}
