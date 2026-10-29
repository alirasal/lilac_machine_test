import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart'; // remove if mobile only
import 'database/app_store.dart';
import 'database/profile_store.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) databaseFactory = databaseFactoryFfiWeb; // remove if mobile only
  await AppStore.instance.load();
  await ProfileStore.instance.load();
  runApp(const ExpenziaApp());
}

class ExpenziaApp extends StatelessWidget {
  const ExpenziaApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Expenzia',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const SplashScreen(),
        builder: (context, child) {
          final mq = MediaQuery.of(context);
          return MediaQuery(
            data: mq.copyWith(
                textScaler: mq.textScaler
                    .clamp(minScaleFactor: .85, maxScaleFactor: 1.2)),
            child: child!,
          );
        },
      );
}
