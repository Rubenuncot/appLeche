import 'package:flutter/cupertino.dart';

import '../database/models/models.dart';

class TanqueProvider extends ChangeNotifier {
  List<Tanque> _tanques = [];

  List<Tanque> get tanques => _tanques;

  set tanques(List<Tanque> value) {
    _tanques = value;
    notifyListeners();
  }
}