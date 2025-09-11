import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/core/theme/aqua_theme.dart'; // 👈 use your water-color theme
import 'features/home/presentation/home_screen.dart';

class JpSongLearnApp extends ConsumerWidget {
  const JpSongLearnApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'JpSong Learn',
      debugShowCheckedModeBanner: false,

      // Localization
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('zh', 'CN'),
        Locale('ja', 'JP'),
      ],

      // 👇 Use the aqua theme instead of redefining ThemeData here
      theme: aquaTheme,

      home: const HomeScreen(),
    );
  }
}
