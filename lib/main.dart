import 'package:chatapp/config/app_config.dart';
import 'package:chatapp/config/theme_config.dart';
import 'package:chatapp/const/strings.dart';
import 'package:chatapp/firebase_options.dart';
import 'package:chatapp/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ChatApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(
        AppConfig.figmaScreenWidth,
        AppConfig.figmaScreenHeight,
      ),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale(Strings.englishLocale, ''),
        ],
        theme: ThemeConfig.lightTheme,
        darkTheme: ThemeConfig.darkTheme,
        routes: Routes.routeList,
        initialRoute: Routes.splash,
        navigatorKey: navigatorKey,
      ),
    );
  }
}