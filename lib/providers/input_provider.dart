import 'package:flutter/material.dart';

class InputProvider extends ChangeNotifier{
  String _valueSearch = '';
  String _valueInd = '';
  String _valueGan = '';
  String _valueLit = '';
  String _valueTemp = '';
  String tanqueName = '';
  List<String> valueLitList = [];
  List<String> valueTempList = [];
  String _valueKil = '';

  String get valueSearch => _valueSearch;

  String get valueInd => _valueInd;

  String get valueGan => _valueGan;

  String get valueKil => _valueKil;

  String get valueLit => _valueLit;

  String get valueTemp => _valueTemp;

  set valueInd(String value) {
    _valueInd = value;
    notifyListeners();
  }

  set valueSearch(String value) {
    _valueSearch = value;
    notifyListeners();
  }


  set valueGan(String value) {
    _valueGan = value;
    notifyListeners();
  }

  set valueKil(String value) {
    _valueKil = value;
    notifyListeners();
  }


  set valueLit(String value) {
    _valueLit = value;
    notifyListeners();
  }

  set valueTemp(String value) {
    _valueTemp = value;
    notifyListeners();
  }

  void setValueTemp(String value) {
    valueTempList.add(value);
    notifyListeners();
  }

  void setValueLit(String value) {
    valueLitList.add(value);
    notifyListeners();
  }

}