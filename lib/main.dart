// @dart=2.9
/* set_state
* controller
* */
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; // подключаем библиотеку material

import 'package:flutter_html/flutter_html.dart';

import 'package:proba1/leftBar.dart';
import 'package:proba1/rightBar.dart';
import 'package:proba1/model.dart';
import 'package:proba1/hint_widget.dart';

import 'article_widget.dart';

final GlobalKey<ScaffoldState> _key = GlobalKey();
final searchController = TextEditingController();
void main() {
  var currentState;

  runApp(
    // перезапускает приложение
    MaterialApp(
      debugShowCheckedModeBanner: false, // скрываем надпись debug
      theme: ThemeData(
        primaryColor: primaryColor,
      ),
      home: HomePage(),
    ),
  );
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const myBorder = const UnderlineInputBorder(
      borderSide: const BorderSide(color: Colors.white, width: 2.0));



  List<String> toShow = [''];

  // final ScrollController _hintScroll = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        drawer: LeftNavDrawer(),
        endDrawer: RDrawer(),
        body: Column(children: [
          head(),
          viewPanel(),
        ]));
  }

  Widget viewPanel() {
    return StreamBuilder<AppState>(
      stream: model.stateStream.stream,
      initialData: AppState.waitForTyping,
      builder: (
        BuildContext context,
        AsyncSnapshot<AppState> snapshot,
      ) {
        AppState curState =
            snapshot.hasData ? snapshot.data : AppState.waitForTyping;
        switch (curState) {
          case AppState.inTyping:
            return HintView();
          case AppState.waitForTyping:
            return ArticleView();//Text("Здесь могла бы быть ваша статья...");
        }
      },
    );
  }


  @override
  Widget head() {
    return Container(
      decoration: const BoxDecoration(
        color: primaryColor,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
          child: Row(
            children: [
              MyIconButton(Icons.menu, () => _key.currentState.openDrawer()),
              const SizedBox(width: 3.0, child: null),
              MyIconButton(
                Icons.search,
                () {
                  model.setState(AppState.waitForTyping);
                  model.fetchArticle();// ??? вызвать метод, вызывающий поиск статьи
                },
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 5.0, bottom: 10.0, left: 5.0, right: 3.0),
                  child: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      border: myBorder,
                      enabledBorder: myBorder,
                      focusedBorder: myBorder,
                      isDense: true,
                      hintText: "Tajpu vorton",
                      hintStyle: TextStyle(color: Colors.white60),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 3.0, vertical: 3.0),
                    ),
                    cursorColor: Colors.white,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                    onChanged: (text) {
                      model.setCurString(text, toRedraw: false);
                      model.fetchHints();
                      model.setState(AppState.inTyping);
                    },
                    onSubmitted: (value) {
                      model.setCurString(value, toRedraw: false);
                      model.setState(AppState.waitForTyping);
                      model.fetchArticle();// ??? вызвать метод, вызывающий поиск статьи
                    },
                    autofocus: true,
                  ),
                ),
              ),
              MyIconButton(Icons.clear, () => {
                searchController.clear(),
                model.setCurString('',)
              }),
              MyIconButton(Icons.arrow_left, () => {}, width: 25.0),
              MyIconButton(Icons.arrow_right, () => {}, width: 25.0),
              MyIconButton(
                  Icons.history, () => _key.currentState.openEndDrawer()),
            ],
          ),
        ),
      ),
    );
  }

  Widget MyIconButton(IconData icon, void Function() func,
      {double width = 30.0}) {
    return SizedBox(
      width: width,
      height: 30.0,
      child: IconButton(
        padding: const EdgeInsets.all(0.0),
        icon: Icon(
          icon,
          size: 25.0,
        ),
        color: Colors.white,
        onPressed: func,
      ),
    );
  }
}
