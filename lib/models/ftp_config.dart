import 'package:transportes_leche/shared_preferences/preferences.dart';

class FTPConfig {
  static final String _host = Preferences.tipoRuta ?? true ? Preferences.pathExterna ?? '' : Preferences.host ?? '';
  static final String _user = Preferences.user ?? '';
  static final String _pass = Preferences.pass ?? '';
  static final String _path = Preferences.pathLocal ?? '';
  static final int _port = Preferences.port ?? 0;

  FTPConfig._();

  static String get host => _host;
  static String get user => _user;
  static String get pass => _pass;
  static int get port => _port;
  static String get path => _path;
}