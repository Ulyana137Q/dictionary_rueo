import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';
import 'package:flutter/material.dart';

import 'main.dart';

enum AppState { waitForTyping, inTyping }

const primaryColor = Color(0xFF548134);
const colorForHints = Color(0x13548134);

final String url = 'https://old.rueo.ru/sercxo/';

class Model {
// Storages
  String _curString = "";
  AppState _state = AppState.waitForTyping;
  List<String> _hints = [];
  String _article = "";

//  StreamControllers
//   StreamController<String> typeStream = StreamController<String>();
//   StreamController<AppState> stateStream = StreamController<AppState>();
//   StreamController<List<String>> hintsStream = StreamController<List<String>>();
//   StreamController<String> articleStream = StreamController<String>();

  StreamController<String> typeStream = StreamController<String>.broadcast();
  StreamController<AppState> stateStream =
  StreamController<AppState>.broadcast();
  StreamController<List<String>> hintsStream =
  StreamController<List<String>>.broadcast();
  StreamController<String> articleStream = StreamController<String>.broadcast();

// Setting data
  void setCurString(String newText, {bool toRedraw = true}) {
    _curString = newText;
    if (toRedraw) {
      searchController.text = newText;
      typeStream.add(_curString);
    }
  }

  void setState(AppState newState) {
    _state = newState;
    stateStream.add(_state);
  }

  void setHints(List<String> newHints) {
    _hints = newHints;
    hintsStream.add(_hints);
  }

  void setArticle(String newArticle) {
    _article = newArticle;
    articleStream.add(_article);
  }

  void fetchHints() {
    http.get(url + '?ajax&term=' + _curString).then(hintsGot);
  }
  void fetchArticle(){
    http.get(url + _curString).then(getArticle);
  }
  String giveArticle(){
    return _article;
  }

  FutureOr<dynamic> hintsGot(http.Response resp) {
    List<String> gotHints = List.from(
        jsonDecode(resp.body)
            .map((hint) => hint['value'] as String)
            .where((hint) => hint != ""),
        growable: false);
    if (gotHints.length == 0) {
      if (_curString.isEmpty){
        gotHints = ['начните вводить текст'];
      } else {
        gotHints = ["Ne estas sugestoj!"];
      }
    }
//    _hintScroll.jumpTo(_hintScroll.position.minScrollExtent);
    setHints(gotHints);
  }

  void getArticle(http.Response responce) async {
    if (responce.statusCode == 200) {
      // вырезает необходимую часть html из сайта
      int firstMatch = responce.body.indexOf('<div class="search_result">');
      String result1 = responce.body.substring(
          firstMatch + '<div class="search_result">'.length,
          responce.body.length);
      int secondMatch = result1.indexOf('<div class="search_result">');
      String tempResult = result1.substring(0, secondMatch);
      int komMatch = tempResult.indexOf('<div class="kom">');
      int endKom = tempResult.indexOf('</div>', komMatch);
      String articleWithoutKom =
          tempResult.substring(0, komMatch + '<div class="kom">'.length) +
              tempResult.substring(endKom + '</div>'.length);
      print('конец загрузки статьи');
      setArticle(articleWithoutKom);

    }

  }
}

Model model = Model();
