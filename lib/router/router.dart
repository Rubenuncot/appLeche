import 'package:flutter/material.dart';

import '../models/menu_option.dart';
import '../screens/screens.dart';

class RoutesList {
  static String initialRoute = "_home";

  static final menuOptions = <MenuOption>[
    MenuOption(
        name: MainScreen.routeName,
        icon: Icons.list,
        screen: const MainScreen(),
        route: MainScreen.routeName),
    MenuOption(
        name: ConfigScreen.routeName,
        icon: Icons.list_alt,
        screen: const ConfigScreen(),
        route: ConfigScreen.routeName),
    MenuOption(
        name: LoadScreen.routeName,
        icon: Icons.alarm,
        screen: const LoadScreen(),
        route: LoadScreen.routeName),
    MenuOption(
        name: DownloadScreen.routeName,
        icon: Icons.call_to_action_rounded,
        screen: const DownloadScreen(),
        route: DownloadScreen.routeName),
    MenuOption(
        name: LoadListScreen.routeName,
        icon: Icons.call_to_action_rounded,
        screen: const LoadListScreen(),
        route: LoadListScreen.routeName),
    MenuOption(
        name: DownloadListScreen.routeName,
        icon: Icons.call_to_action_rounded,
        screen: const DownloadListScreen(),
        route: DownloadListScreen.routeName),
    MenuOption(
        name: SearchScreen.routeName,
        icon: Icons.call_to_action_rounded,
        screen: const SearchScreen(),
        route: SearchScreen.routeName),
    MenuOption(
        name: PrintBluetooth.routeName,
        icon: Icons.call_to_action_rounded,
        screen: const PrintBluetooth(),
        route: PrintBluetooth.routeName),
  ];

  static Map<String, Widget Function(BuildContext)> getAppRoutes() {
    Map<String, Widget Function(BuildContext)> appRoutes = {};

    for (final e in menuOptions) {
      appRoutes.addAll({e.route: (BuildContext context) => e.screen});
    }

    return appRoutes;
  }

  static Route<dynamic>? onGeneratedRoute(RouteSettings settings) {
    return MaterialPageRoute(builder: (context) => const MainScreen());
  }
}
