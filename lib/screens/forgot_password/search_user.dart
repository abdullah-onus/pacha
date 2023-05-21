import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:pacha/models/recovery_code_arguments.dart';
import 'package:pacha/constants.dart';
import 'package:pacha/pacha_api.dart';

class ScreenSearchUser extends StatefulWidget {
  const ScreenSearchUser({Key? key}) : super(key: key);
  @override
  _ScreenSearchUserState createState() => _ScreenSearchUserState();
}

class _ScreenSearchUserState extends State<ScreenSearchUser> {
  final textEditingControllerUserMail = TextEditingController();
  bool isConnectingToAPI = false;
  bool isUserMailEmpty = true;
  static String maskedEmail = '';
  static int userID = 0;
  void searchUser(BuildContext context) async {
    PaChaAPI().userSearch(textEditingControllerUserMail.text).then((response) {
      Map<String, dynamic> json = (response as Map)['json'];
      userID = json['id'];
      PaChaAPI().passwordVerificationResend(userID).then((verificationResponse) {
        if (verificationResponse['code'] == 200) {
          setState(() {
            maskedEmail = json['masked_email'];
          });
          Navigator.of(context).pushReplacementNamed('/forgot-password/recovery-code',
              arguments: RecoveryCodeArguments(
                email: maskedEmail,
                userID: userID,
              ));
        }
      });
    }).whenComplete(() {
      setState(() {
        isConnectingToAPI = false;
      });
    }).onError((error, stackTrace) {
      setState(() {
        isConnectingToAPI = false;
      });
      debugPrint("$error");
      if ((error as Map)['code'] == -1) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).apiErrorUnableToConnect)));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).apiErrorInvalidUserOrPassword)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
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
                          AppLocalizations.of(context).screenSearchUserTextSubtitle,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline2,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: Constants().padding),
                        child: Text(
                          AppLocalizations.of(context).screenSearchUserTextDescription,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: Constants().padding * 2),
                        child: TextField(
                          controller: textEditingControllerUserMail,
                          onChanged: (value) {
                            setState(() {
                              isUserMailEmpty = textEditingControllerUserMail.text.isEmpty;
                            });
                          },
                          keyboardType: TextInputType.emailAddress,
                          autofocus: true,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context).screenLoginTextFieldUsernameText,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: isConnectingToAPI ? 0 : Constants().padding),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: isUserMailEmpty
                                    ? null
                                    : isConnectingToAPI
                                        ? null
                                        : () {
                                            setState(() {
                                              isConnectingToAPI = true;
                                            });
                                            searchUser(context);
                                          },
                                child: Text(
                                  (AppLocalizations.of(context).screenSearchUserElevetedButtonSearchText),
                                ),
                              ),
                            ),
                          ],
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
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed('/onboarding/signup');
                          },
                          child: Text(
                            AppLocalizations.of(context).screenLoginTextButtonCreateAccountText,
                          ),
                        ),
                      ),
                    ]),
              ),
            ),
          ),
        );
      }),
    ));
  }
}
