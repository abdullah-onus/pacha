import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pacha/constants.dart';
import 'package:pacha/globals.dart';
import 'package:pacha/models/verification_code_arguments.dart';
import 'package:pacha/pacha_api.dart';
import 'package:pacha/settings.dart';
import 'package:url_launcher/url_launcher.dart';

class ScreenSignup extends StatefulWidget {
  const ScreenSignup({Key? key}) : super(key: key);
  @override
  _ScreenSignupState createState() => _ScreenSignupState();
}

class _ScreenSignupState extends State<ScreenSignup> {
  final GlobalKey<FormFieldState<String>> passwordFieldKey = GlobalKey<FormFieldState<String>>();
  final textEditingControllerFullname = TextEditingController();
  final textEditingControllerEmail = TextEditingController();
  final textEditingControllerPassword = TextEditingController();
  final textEditingControllerConfirmPassword = TextEditingController();
  final textEditingControllerDateController = TextEditingController();
  late DateTime birthday;
  bool isPasswordVisible = true;
  bool isConfirmPasswordVisible = true;
  bool isOccupationEmpty = true;
  int categoryIndex = 0;
  String whiteList = "0123456789";
  bool isConnectingToAPI = false;
  bool isRegisterDisabled = false;
  static String maskedEmail = '';
  static int userID = 0;
  void register(BuildContext context) async {
    setState(() {
      isConnectingToAPI = true;
      isRegisterDisabled = true;
    });
    PaChaAPI()
        .userSignup(
            category: categoryIndex,
            fullname: textEditingControllerFullname.text,
            email: textEditingControllerEmail.text,
            password1: textEditingControllerPassword.text,
            password2: textEditingControllerConfirmPassword.text,
            birthday: birthday.toString(),
            language: Globals.userLocale.toString())
        .then((response) {
      Map<String, dynamic> json = (response as Map)['json'];
      setState(() {
        maskedEmail = json['masked_email'];
        userID = json['id'];
      });
      Navigator.of(context).pushReplacementNamed('/onboarding/verification-code', arguments: VerificationCodeArguments(email: maskedEmail, userID: userID));
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

  _ScreenSignupState() {
    String? pattern = DateFormat.yMd(Settings().getLanguage).pattern;
    List patternPieces = [
      ...{...DateFormat.yMd(Settings().getLanguage).parsePattern(pattern!)}
    ];
    for (var field in patternPieces) {
      if (![
            DateFormat.ABBR_MONTH,
            DateFormat.ABBR_MONTH_DAY,
            DateFormat.ABBR_MONTH_WEEKDAY_DAY,
            DateFormat.ABBR_QUARTER,
            DateFormat.ABBR_STANDALONE_MONTH,
            DateFormat.ABBR_WEEKDAY,
            DateFormat.DAY,
            DateFormat.HOUR,
            DateFormat.HOUR24,
            DateFormat.HOUR24_MINUTE,
            DateFormat.HOUR24_MINUTE_SECOND,
            DateFormat.HOUR_GENERIC_TZ,
            DateFormat.HOUR_MINUTE,
            DateFormat.HOUR_MINUTE_GENERIC_TZ,
            DateFormat.HOUR_MINUTE_SECOND,
            DateFormat.HOUR_MINUTE_TZ,
            DateFormat.HOUR_TZ,
            DateFormat.MINUTE,
            DateFormat.MINUTE_SECOND,
            DateFormat.MONTH,
            DateFormat.MONTH_DAY,
            DateFormat.MONTH_WEEKDAY_DAY,
            DateFormat.NUM_MONTH,
            DateFormat.NUM_MONTH_DAY,
            DateFormat.NUM_MONTH_WEEKDAY_DAY,
            DateFormat.QUARTER,
            DateFormat.SECOND,
            DateFormat.STANDALONE_MONTH,
            DateFormat.WEEKDAY,
            DateFormat.YEAR,
            DateFormat.YEAR_ABBR_MONTH,
            DateFormat.YEAR_ABBR_MONTH_DAY,
            DateFormat.YEAR_ABBR_MONTH_WEEKDAY_DAY,
            DateFormat.YEAR_ABBR_QUARTER,
            DateFormat.YEAR_MONTH,
            DateFormat.YEAR_MONTH_DAY,
            DateFormat.YEAR_MONTH_WEEKDAY_DAY,
            DateFormat.YEAR_NUM_MONTH,
            DateFormat.YEAR_NUM_MONTH_DAY,
            DateFormat.YEAR_NUM_MONTH_WEEKDAY_DAY,
            DateFormat.YEAR_QUARTER
          ].contains(field.toString()) &&
          !whiteList.contains(field.toString())) whiteList += field.toString();
    }
  }
  bool checkMandatoriesSections() {
    return textEditingControllerFullname.text.isEmpty ||
        textEditingControllerEmail.text.isEmpty ||
        textEditingControllerPassword.text.isEmpty ||
        textEditingControllerConfirmPassword.text.isEmpty ||
        textEditingControllerDateController.text.isEmpty ||
        isOccupationEmpty;
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
                          AppLocalizations.of(context).screenSignupTextCreateAccount,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline2,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: Constants().padding),
                        child: DropdownButtonFormField<String>(
                          isExpanded: true,
                          items: AppLocalizations.of(context).screenSignupCategoryList.split(",").map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          decoration: InputDecoration(labelText: AppLocalizations.of(context).screenSignupCategoryFieldText),
                          onChanged: (String? value) {
                            setState(() {
                              value != "" ? isOccupationEmpty = false : isOccupationEmpty = true;
                              categoryIndex = (value == '' ? null : AppLocalizations.of(context).screenSignupCategoryList.split(",").indexOf(value!))!;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: Constants().padding),
                        child: TextFormField(
                          controller: textEditingControllerFullname,
                          textInputAction: TextInputAction.next,
                          onChanged: (value) {
                            setState(() {
                              checkMandatoriesSections();
                            });
                          },
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context).screenSignupTextFieldFullnameText,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: Constants().padding),
                        child: TextFormField(
                          controller: textEditingControllerEmail,
                          textInputAction: TextInputAction.next,
                          onChanged: (value) {
                            setState(() {
                              checkMandatoriesSections();
                            });
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context).screenSignupTextFieldEmailText,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: Constants().padding),
                        child: TextField(
                          controller: textEditingControllerPassword,
                          textInputAction: TextInputAction.next,
                          onChanged: (value) {
                            setState(() {
                              checkMandatoriesSections();
                            });
                          },
                          obscureText: isPasswordVisible,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context).screenSignupTextFieldPasswordText,
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
                          controller: textEditingControllerConfirmPassword,
                          onChanged: (value) {
                            setState(() {
                              checkMandatoriesSections();
                            });
                          },
                          obscureText: isConfirmPasswordVisible,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context).screenSignupTextFieldConfirmPasswordText,
                            suffixIcon: IconButton(
                              splashRadius: 1,
                              icon: isConfirmPasswordVisible ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),
                              onPressed: () => setState(() => isConfirmPasswordVisible = !isConfirmPasswordVisible),
                            ),
                          ),
                        ),
                      ),
                      Focus(
                        child: TextField(
                          keyboardType: TextInputType.datetime,
                          readOnly: true,
                          textInputAction: TextInputAction.next,
                          controller: textEditingControllerDateController,
                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"[" + whiteList + "]"))],
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context).screenSignupTextFieldDateOfBirthText,
                            hintText: DateFormat.yMd(Settings().getLanguage).pattern,
                            suffixIcon: const Icon(Icons.calendar_today),
                          ),
                          onTap: () async {
                            var date = await showDatePicker(
                              context: context,
                              initialDate: DateTime(DateTime.now().year - 18, DateTime.now().month, DateTime.now().day),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );
                            try {
                              birthday = DateTime(date!.year, date.month, date.day, date.hour, date.minute, date.second);
                              textEditingControllerDateController.text = DateFormat.yMMMMd(Settings().getLanguage).format(date.toLocal());
                              setState(() {
                                birthday = DateTime(date.year, date.month, date.day, date.hour, date.minute, date.second);
                                checkMandatoriesSections();
                              });
                            } catch (exception) {
                              setState(() {
                                checkMandatoriesSections();
                              });
                            }
                          },
                        ),
                        onFocusChange: (hasFocus) {
                          if (hasFocus) {
                            textEditingControllerDateController.text = DateFormat.yMd(Settings().getLanguage)
                                .format(DateFormat.yMMMMd(Settings().getLanguage).parse(textEditingControllerDateController.text));
                          } else {
                            textEditingControllerDateController.text = DateFormat.yMMMMd(Settings().getLanguage)
                                .format(DateFormat.yMd(Settings().getLanguage).parse(textEditingControllerDateController.text));
                          }
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: Constants().padding),
                        child: Text(
                          AppLocalizations.of(context).screenSignupTextFildDateOfBirthDescription,
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: Constants().padding),
                        child: ElevatedButton(
                          onPressed: (checkMandatoriesSections())
                              ? null
                              : () {
                                  if (textEditingControllerPassword.text == textEditingControllerConfirmPassword.text) {
                                    register(context);
                                  } else if (textEditingControllerPassword.text.length < 8 || textEditingControllerConfirmPassword.text.length < 8) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).screenSignupPasswordLength)));
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).screenSignupPasswordsAreIdentical)));
                                  }
                                },
                          child: Text(
                            (AppLocalizations.of(context).screenSignupElevatedButtonCreateText),
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
                        child: RichText(
                          text: TextSpan(children: [
                            TextSpan(text: AppLocalizations.of(context).screenSignupPolicyPretext, style: Theme.of(context).textTheme.bodyText1),
                            TextSpan(
                                text: AppLocalizations.of(context).screenSignupPolicyTermsOfService,
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    launch(AppLocalizations.of(context).appUrlTermsOfService);
                                  },
                                style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Theme.of(context).colorScheme.primary)),
                            TextSpan(text: AppLocalizations.of(context).screenSignupPolicySuftext, style: Theme.of(context).textTheme.bodyText1),
                            TextSpan(
                              text: AppLocalizations.of(context).screenSignupPolicyPrivacyPolicy,
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  launch(AppLocalizations.of(context).appUrlPrivacyPolicy);
                                },
                              style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Theme.of(context).colorScheme.primary),
                            ),
                            TextSpan(text: AppLocalizations.of(context).screenSignupPolicySuftextSecond, style: Theme.of(context).textTheme.bodyText1),
                          ]),
                        ),
                      )
                    ]),
              ),
            ),
          ),
        );
      }),
    ));
  }
}
