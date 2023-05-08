import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static late SharedPreferences _prefs;

  static String? _conductor = '';
  static String? _matricula = '';
  static String? _mac = '';
  static String? _host = '';
  static String? _user = '';
  static String? _pass = '';
  static String? _path = '';
  static String? _themeName = '';
  static String? _cooperativa = '';
  static bool? _theme = false;
  static int? _port = 0;

  static Future init() async{
    _prefs = await SharedPreferences.getInstance();
  }

  static String? get matricula => _prefs.getString('matricula') ?? _matricula;
  static String? get cooperativa => _prefs.getString('cooperativa') ?? _cooperativa;
  static String? get mac => _prefs.getString('mac') ?? _mac;
  static String? get host => _prefs.getString('host') ?? _host;
  static String? get user => _prefs.getString('user') ?? _user;
  static String? get pass => _prefs.getString('pass') ?? _pass;
  static String? get path => _prefs.getString('path') ?? _path;
  static String? get themeName => _prefs.getString('themeName') ?? _themeName;
  static bool? get theme => _prefs.getBool('theme') ?? _theme;
  static int? get port => _prefs.getInt('port') ?? _port;
  static String? get conductor => _prefs.getString('conductor') ?? _conductor;

  static set matricula(String? value) {
    _matricula = value;
    _prefs.setString('matricula', _matricula!);
  }

  static set mac(String? value) {
    _mac = value;
    _prefs.setString('mac', _mac!);
  }

  static set cooperativa(String? value) {
    _cooperativa = value;
    _prefs.setString('cooperativa', _cooperativa!);
  }

  static set host(String? value) {
    _host = value;
    _prefs.setString('host', _host!);
  }

  static set user(String? value) {
    _user = value;
    _prefs.setString('user', _user!);
  }

  static set pass(String? value) {
    _pass = value;
    _prefs.setString('pass', _pass!);
  }

  static set path(String? value) {
    _path = value;
    _prefs.setString('path', _path!);
  }

  static set themeName(String? value) {
    _themeName = value;
    _prefs.setString('themeName', _themeName!);
  }

  static set theme(bool? value) {
    _theme = value;
    _prefs.setBool('theme', _theme!);
  }

  static set port(int? value) {
    _port = value;
    _prefs.setInt('port', _port!);
  }

  static set conductor(String? value) {
    _conductor = value;
    _prefs.setString('conductor', _conductor!);
  }


}