import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pacha/change_password.dart';
import 'package:pacha/globals.dart';
import 'package:pacha/screens/calendar_screen.dart';
import 'package:pacha/screens/challenge_selection.dart';
import 'package:pacha/screens/chat/chat_screen.dart';
import 'package:pacha/screens/chat/chat_screen_channel.dart';
import 'package:pacha/screens/chat/chat_screen_user.dart';
import 'package:pacha/screens/events/event_editor.dart';
import 'package:pacha/screens/events/people_picker.dart';
import 'package:pacha/screens/feed_screen.dart';
import 'package:pacha/screens/forgot_password/recovery_code.dart';
import 'package:pacha/screens/forgot_password/reset_password.dart';
import 'package:pacha/screens/forgot_password/search_user.dart';
import 'package:pacha/screens/main_screen.dart';
import 'package:pacha/screens/map_location_picker.dart';
import 'package:pacha/screens/onboarding/login.dart';
import 'package:pacha/screens/onboarding/signup.dart';
import 'package:pacha/screens/onboarding/verification_code.dart';
import 'package:pacha/screens/profile/profile_edit_page.dart';
import 'package:pacha/screens/profile/profile_page.dart';

import 'package:pacha/screens/qr_generator_screen.dart';
import 'package:pacha/screens/platform_info.dart';
import 'package:pacha/settings.dart';
import 'package:pacha/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Settings().init();
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  static Map<String, Widget Function(BuildContext)> routes = {};

  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    routes = {
      '/main': (context) => const ScreenMain(),
      '/calendar_screen': (context) => const ScreenCalendar(),
      '/calendar/pick_people': (context) => const PeoplePicker(),
      '/chat_screen': (context) => const ScreenChat(),
      '/chat_screen_user': (context) => const ScreenChatUser(),
      '/chat_screen_channel': (context) => const ScreenChatChannel(),
      '/event_editor': (context) => const EventEditor(),
      '/forgot-password/recovery-code': (context) => const ScreenRecoveryCode(),
      '/forgot-password/reset-password': (context) =>
          const ScreenResetPassword(),
      '/forgot-password/search-user': (context) => const ScreenSearchUser(),
      '/map_picker': (context) => const MapPicker(),
      '/challenges': (context) => const ScreenChallengeSelection(),
      '/onboarding/login': (context) => const ScreenLogin(),
      '/onboarding/signup': (context) => const ScreenSignup(),
      '/onboarding/verification-code': (context) =>
          const ScreenVerificationCode(),
      '/profile/details': (context) {
        if (Globals.user == null) {
          // handle null case
          return Container();
        } else {
          return ProfilePage(userID: Globals.user!.id!);
        }
      },
      '/profile/edit': (context) => const ProfileEditPage(),
      '/qr_code_generator': (context) =>
          const QRCodeGenerator(qrData: "www.paradisechallenge.com"),
      '/settings/platform_info': (context) => const PlatformInfo(),
      '/change_password': (context) => const ScreenChangePassword(),
      '/feed_screen': (context) => const ScreenFeed(),
    };
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localeResolutionCallback: (deviceLocale, supportedLocales) {
        Globals.userLocale = deviceLocale;
        return null;
      },
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
      ],
      title: 'The Paradise Challenge',
      theme: PachaTheme.get,
      initialRoute: '/main',
      routes: routes,
    );
  }
}
