import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static late SharedPreferences _prefs;

  static String? _conductor = '';
  static String? _matricula = '';
  static String? _mac = '';
  static String? _host = '81.42.222.136';
  static String? _user = 'tablet';
  static String? _pass = 'tablet2014*';
  static String? _pathLocal = '';
  static String? _pathExterna = '';
  static String? _themeName = '';
  static String? _cooperativa = 'NombreCooperativa';
  static bool? _tipoRuta = true;
  static bool? _theme = false;
  static int? _port = 3021;

  static Future init() async{
    _prefs = await SharedPreferences.getInstance();
  }

  static String? get matricula => _prefs.getString('matricula') ?? _matricula;
  static String? get cooperativa => _prefs.getString('cooperativa') ?? _cooperativa;
  static String? get mac => _prefs.getString('mac') ?? _mac;
  static String? get host => _prefs.getString('host') ?? _host;
  static String? get user => _prefs.getString('user') ?? _user;
  static String? get pass => _prefs.getString('pass') ?? _pass;
  static String? get pathLocal => _prefs.getString('pathLocal') ?? _pathLocal;
  static String? get pathExterna => _prefs.getString('pathExterna') ?? _pathExterna;
  static String? get themeName => _prefs.getString('themeName') ?? _themeName;
  static bool? get theme => _prefs.getBool('theme') ?? _theme;
  static int? get port => _prefs.getInt('port') ?? _port;
  static String? get conductor => _prefs.getString('conductor') ?? _conductor;
  static bool? get tipoRuta => _prefs.getBool('tipoRuta') ?? _tipoRuta;

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

  static set pathLocal(String? value) {
    _pathLocal = value;
    _prefs.setString('pathLocal', _pathLocal!);
  }

  static set pathExterna(String? value) {
    _pathExterna = value;
    _prefs.setString('pathExterna', _pathExterna!);
  }

  static set themeName(String? value) {
    _themeName = value;
    _prefs.setString('themeName', _themeName!);
  }

  static set theme(bool? value) {
    _theme = value;
    _prefs.setBool('theme', _theme!);
  }

  static set tipoRuta(bool? value) {
    _tipoRuta = value;
    _prefs.setBool('tipoRuta', _tipoRuta!);
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