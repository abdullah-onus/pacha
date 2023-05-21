import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:pacha/constants.dart';
import 'package:pacha/models/reset_code_arguments.dart';
import 'package:pacha/pacha_api.dart';

class ScreenResetPassword extends StatefulWidget {
  const ScreenResetPassword({Key? key}) : super(key: key);
  @override
  _ScreenResetPasswordState createState() => _ScreenResetPasswordState();
}

class _ScreenResetPasswordState extends State<ScreenResetPassword> {
  bool isConfirmPasswordVisible = true;
  bool isResetPasswordVisible = true;
  final textEditingControllerConfirmPassword = TextEditingController();
  final textEditingControllerNewPassword = TextEditingController();
  bool isConfirmPasswordEmpty = true;
  bool isResetPasswordEmpty = true;
  static int userID = 0;
  bool isConnectingToAPI = false;
  String passwordVerificationCode = '';
  void changePassword(BuildContext context) {
    setState(() {
      isConnectingToAPI = true;
    });
    PaChaAPI()
        .passwordChange(
      userID,
      passwordVerificationCode,
      textEditingControllerConfirmPassword.text,
      textEditingControllerNewPassword.text,
    )
        .then((response) {
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
      debugPrint('$error');
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ResetCodeArguments;
    userID = args.userID!;
    passwordVerificationCode = args.userPasswordVerificationCode!;
    return SafeArea(
      child: StreamBuilder<Object>(builder: (BuildContext context, AsyncSnapshot snapshot) {
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
                              AppLocalizations.of(context).screenResetPasswordTextSubtitle,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headline2,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: Constants().padding),
                            child: Text(
                              AppLocalizations.of(context).screenResetPasswordTextDescription,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: Constants().padding),
                            child: TextField(
                              controller: textEditingControllerNewPassword,
                              onChanged: (value) {
                                setState(() {
                                  isResetPasswordEmpty = textEditingControllerNewPassword.text.isEmpty;
                                });
                              },
                              onSubmitted: (_) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("next")));
                              },
                              obscureText: isResetPasswordVisible,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context).screenResetPasswordTextFieldNewPasswordText,
                                suffixIcon: IconButton(
                                  splashRadius: 1,
                                  icon: isResetPasswordVisible ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),
                                  onPressed: () => setState(() => isResetPasswordVisible = !isResetPasswordVisible),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: Constants().padding * 2),
                            child: TextField(
                              controller: textEditingControllerConfirmPassword,
                              onChanged: (value) {
                                setState(() {
                                  isConfirmPasswordEmpty = textEditingControllerConfirmPassword.text.isEmpty;
                                });
                              },
                              onSubmitted: (_) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("next")));
                              },
                              obscureText: isConfirmPasswordVisible,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context).screenResetPasswordTextFieldConfirmNewPasswordText,
                                suffixIcon: IconButton(
                                  splashRadius: 1,
                                  icon: isConfirmPasswordVisible ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),
                                  onPressed: () => setState(() => isConfirmPasswordVisible = !isConfirmPasswordVisible),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: isConnectingToAPI ? 0 : Constants().padding),
                            child: Row(children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: (isResetPasswordEmpty || isConfirmPasswordEmpty) || isConnectingToAPI
                                      ? null
                                      : () {
                                          if (textEditingControllerNewPassword.text.length < 8 || textEditingControllerConfirmPassword.text.length < 8) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text(AppLocalizations.of(context).screenResetPasswordSnackbarInsufficientCharacterText)));
                                          } else if (textEditingControllerNewPassword.text == textEditingControllerConfirmPassword.text) {
                                            changePassword(context);
                                          } else {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text(AppLocalizations.of(context).screenResetPasswordSnackbarInvalidPasswordText)));
                                          }
                                        },
                                  child: Text(
                                    (AppLocalizations.of(context).screenResetPasswordElevetedButtonText),
                                  ),
                                ),
                              ),
                            ]),
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
                        ]),
                  ),
                ),
              );
            }));
      }),
    );
  }
}
