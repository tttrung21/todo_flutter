import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo_app/localization/language_provider.dart';
import 'package:todo_app/project/home/view_model/home_viewmodel.dart';
import 'package:todo_app/project/newtask/view_model/newtask_viewmodel.dart';
import 'package:todo_app/project/splash/splash_screen.dart';
import 'package:todo_app/shared/configs.dart';

import 'generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: Configs.apiBaseUrl,
    anonKey: Configs.apiKey,
  );
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => HomeViewModel()),
    ChangeNotifierProvider(create: (context) => NewTaskViewModel()),
    ChangeNotifierProvider(create: (context) => LanguageProvider()..loadLanguage())
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final langProvider = Provider.of<LanguageProvider>(context);

    return MaterialApp(
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      locale: langProvider.locale,
      supportedLocales: S.delegate.supportedLocales,
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}
