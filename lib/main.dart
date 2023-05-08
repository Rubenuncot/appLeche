import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transportes_leche/models/ftp_config.dart';
import 'package:transportes_leche/providers/fpt_provider.dart';
import 'package:transportes_leche/providers/input_provider.dart';
import 'package:transportes_leche/providers/model_provider.dart';
import 'package:transportes_leche/providers/tanque_provider.dart';
import 'package:transportes_leche/providers/theme_provider.dart';
import 'package:transportes_leche/router/router.dart';
import 'package:transportes_leche/shared_preferences/preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences.init();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => ThemeProvider(isDarkMode: Preferences.theme ?? false),
      ),
      ChangeNotifierProvider(
        create: (context) => ModelProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => FtpService(host: FTPConfig.host, user: FTPConfig.user, pass: FTPConfig.pass, port: FTPConfig.port, path: FTPConfig.path),
      ),
      ChangeNotifierProvider(
        create: (context) => InputProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => TanqueProvider(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Transportes App',
      initialRoute: RoutesList.initialRoute,
      routes: RoutesList.getAppRoutes(),
      onGenerateRoute: RoutesList.onGeneratedRoute,
      theme: Provider.of<ThemeProvider>(context).currentTheme,
    );
  }
}
