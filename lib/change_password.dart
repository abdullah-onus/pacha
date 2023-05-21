import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:pacha/constants.dart';
import 'package:pacha/pacha_api.dart';

class ScreenChangePassword extends StatefulWidget {
  const ScreenChangePassword({Key? key}) : super(key: key);
  @override
  _ScreenChangePasswordState createState() => _ScreenChangePasswordState();
}

class _ScreenChangePasswordState extends State<ScreenChangePassword> {
  bool isConfirmPasswordVisible = true;
  bool isResetPasswordVisible = true;
  bool isPasswordVisible = true;
  final textEditingControllerConfirmPassword = TextEditingController();
  final textEditingControllerNewPassword = TextEditingController();
  final textEditingControllerOldPassword = TextEditingController();
  bool isConfirmNewPasswordEmpty = true;
  bool isNewPasswordEmpty = true;
  bool isOldPasswordEmpty = true;
  bool isConnectingToAPI = false;
  void userPasswordChange(BuildContext context) {
    setState(() {
      isConnectingToAPI = true;
    });
    PaChaAPI()
        .userPasswordChange(
      textEditingControllerOldPassword.text,
      textEditingControllerNewPassword.text,
      textEditingControllerConfirmPassword.text,
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
                              AppLocalizations.of(context).screenChancePasswordTextTitle,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headline2,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: Constants().padding),
                            child: Text(
                              AppLocalizations.of(context).screenChancePasswordTextDescription,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: Constants().padding),
                            child: TextField(
                              textInputAction: TextInputAction.next,
                              controller: textEditingControllerOldPassword,
                              onChanged: (value) {
                                setState(() {
                                  isOldPasswordEmpty = textEditingControllerOldPassword.text.isEmpty;
                                });
                              },
                              obscureText: isPasswordVisible,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context).screenChancePasswordTextFieldPasswordText,
                                suffixIcon: IconButton(
                                  splashRadius: 1,
                                  icon: isPasswordVisible ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),
                                  onPressed: () => setState(() => isPasswordVisible = !isPasswordVisible),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: Constants().padding),
                            child: TextField(
                              textInputAction: TextInputAction.next,
                              controller: textEditingControllerNewPassword,
                              onChanged: (value) {
                                setState(() {
                                  isNewPasswordEmpty = textEditingControllerNewPassword.text.isEmpty;
                                });
                              },
                              obscureText: isResetPasswordVisible,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context).screenChancePasswordTextFieldNewPasswordText,
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
                              textInputAction: TextInputAction.done,
                              controller: textEditingControllerConfirmPassword,
                              onChanged: (value) {
                                setState(() {
                                  isConfirmNewPasswordEmpty = textEditingControllerConfirmPassword.text.isEmpty;
                                });
                              },
                              obscureText: isConfirmPasswordVisible,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context).screenChancePasswordTextFieldConfirmNewPasswordText,
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
                                  onPressed: (isNewPasswordEmpty || isConfirmNewPasswordEmpty || isOldPasswordEmpty) || isConnectingToAPI
                                      ? null
                                      : () {
                                          if (textEditingControllerNewPassword.text.length < 8 || textEditingControllerConfirmPassword.text.length < 8) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text(AppLocalizations.of(context).screenChancePasswordSnackbarInsufficientCharacterText)));
                                          } else if (textEditingControllerNewPassword.text == textEditingControllerConfirmPassword.text &&
                                              textEditingControllerNewPassword.text != textEditingControllerOldPassword.text) {
                                            userPasswordChange(context);
                                          } else if (textEditingControllerOldPassword.text == textEditingControllerNewPassword.text) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text(AppLocalizations.of(context).screenChancePasswordSnackbarSamePasswordText)));
                                          } else if (textEditingControllerNewPassword.text != textEditingControllerConfirmPassword.text) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text(AppLocalizations.of(context).screenChancePasswordSnackbarInvalidPasswordText)));
                                          }
                                        },
                                  child: Text(
                                    (AppLocalizations.of(context).screenChangePasswordElevetedButtonText),
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
                          Padding(
                            padding: EdgeInsets.only(bottom: Constants().padding),
                            child: Align(
                              alignment: Alignment.center,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamed('/forgot-password/search-user');
                                },
                                child: Text(AppLocalizations.of(context).screenLoginTextButtonForgotPasswordText),
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
