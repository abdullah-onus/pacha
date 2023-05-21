import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:pacha/globals.dart';
import 'package:pacha/models/verification_code_arguments.dart';
import 'package:pacha/pacha_api.dart';
import 'package:pacha/models/user_details.dart';
import 'package:pacha/models/challenge_details.dart';
import 'package:pacha/constants.dart';

class ScreenLogin extends StatefulWidget {
  const ScreenLogin({Key? key}) : super(key: key);
  @override
  _ScreenLoginState createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {
  bool isPasswordInvisible = true;
  final textEditingControllerUsername = TextEditingController(text: 'x');
  final textEditingControllerPassword = TextEditingController(text: 'x');
  bool isLoginDisabled = false;
  bool invalidUsernameOrPassword = false;
  bool apiError = false;
  bool isConnectingToAPI = false;
  static String maskedEmail = '';
  static int userID = 0;
  void login(BuildContext context) async {
    setState(() {
      isPasswordInvisible = true;
      isConnectingToAPI = true;
      isLoginDisabled = true;
    });
    PaChaAPI().userLogin(textEditingControllerUsername.text, textEditingControllerPassword.text).then((response) {
      Map<String, dynamic> json = (response as Map)['json'];
      Globals.user = UserDetails.fromJson(json);
      if (json['status'].toString() == 'active') {
        if (json['challenge'] == null) {
          Navigator.of(context).pushReplacementNamed('/challenges');
        } else {
          PaChaAPI().challengeGet(Globals.user!.challenge!).then((response) {
            Map<String, dynamic> json = (response as Map)['json'];
            Globals.challenge = ChallengeDetails.fromJson(json);
            Navigator.of(context).pushReplacementNamed('/main');
          }).onError((error, stackTrace) {
            int code = (error as Map)['code'];
            if (code == -1) {
              setState(() {
                apiError = true;
              });
            } else if (code == 401) {
              setState(() {
                invalidUsernameOrPassword = true;
              });
            }
          }).whenComplete(() => setState(() {
                isConnectingToAPI = false;
              }));
        }
      } else if (json['status'].toString() == 'not_verified') {
        setState(() {
          maskedEmail = json['masked_email'];
          userID = json['id'];
        });
        PaChaAPI().signUpVerificationResend(userID).then((response) {}).whenComplete(() {}).onError((error, stackTrace) {});
        Navigator.of(context).pushReplacementNamed('/onboarding/verification-code', arguments: VerificationCodeArguments(email: maskedEmail, userID: userID));
      }
    }).onError((error, stackTrace) {
      setState(() {
        isConnectingToAPI = false;
      });
      if ((error as Map)['code'] == -1) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).apiErrorUnableToConnect)));
      } else if ((error)['code'] == 401) {
        setState(() {
          invalidUsernameOrPassword = true;
        });
      }
    });
  }

  void verificationNew(BuildContext context) async {
    PaChaAPI().signUpVerificationResend(userID).then((response) {}).whenComplete(() {
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
    return SafeArea(child: Scaffold(
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/logo.png',
                        width: 256,
                        height: 256,
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: Constants().padding),
                        child: TextField(
                          controller: textEditingControllerUsername,
                          textInputAction: TextInputAction.next,
                          onChanged: (value) {
                            setState(() {
                              isLoginDisabled = textEditingControllerUsername.text.isEmpty || textEditingControllerPassword.text.isEmpty;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: (AppLocalizations.of(context).screenLoginTextFieldUsernameText),
                            errorText: invalidUsernameOrPassword ? "Invalid username or password" : null,
                          ),
                        ),
                      ),
                      TextField(
                        controller: textEditingControllerPassword,
                        onChanged: (value) {
                          setState(() {
                            isLoginDisabled = textEditingControllerUsername.text.isEmpty || textEditingControllerPassword.text.isEmpty;
                          });
                        },
                        onSubmitted: (_) {
                          login(context);
                        },
                        obscureText: isPasswordInvisible,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context).screenLoginTextFieldPasswordText,
                          suffixIcon: IconButton(
                            splashRadius: 1,
                            icon: isPasswordInvisible ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),
                            onPressed: () => setState(() => isPasswordInvisible = !isPasswordInvisible),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: Constants().padding),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed('/forgot-password/search-user');
                            },
                            child: Text(AppLocalizations.of(context).screenLoginTextButtonForgotPasswordText),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: isConnectingToAPI ? 0 : 16),
                        child: Row(children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: isLoginDisabled
                                  ? null
                                  : () {
                                      login(context);
                                    },
                              child: Text(
                                (AppLocalizations.of(context).screenLoginElevetedButtonLoginText),
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
                      Align(
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed('/onboarding/signup');
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
