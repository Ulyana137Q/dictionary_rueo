import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import 'package:proba1/main.dart';
import 'package:proba1/model.dart';
final searchController = TextEditingController();

enum StateApp { start, hints, article }

class SearchField extends StatefulWidget {
  //SearchField({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SearchState();
}

class SearchState extends State<SearchField> {
  final _formKey = GlobalKey<FormState>();

  static const myBorder = const UnderlineInputBorder(
      borderSide: const BorderSide(color: Colors.white, width: 2.0));

  @override
  Widget build(BuildContext context) {
    String searchtxt = '';
    return Expanded(
      flex: 1,
      child: Padding(
        padding: EdgeInsets.only(top: 5.0, bottom: 10.0, left: 5.0, right: 3.0),
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
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
          onChanged: (text) {},
          onSubmitted: (value) {
            //HomePage(state: 2);
          },
          autofocus: true,
        ),
      ),
    );
  }
}

// class Head extends StatefulWidget {
//    Head({ Key? key}) : super(key: key);
//
//   @override
//   _HeadState createState() => _HeadState();
// }
//
// class _HeadState extends State<HomePage> {
//
//   static const myBorder = const UnderlineInputBorder(
//       borderSide: const BorderSide(color: Colors.white, width: 2.0));
//
//   @override
//   Widget build(BuildContext context) {
//     var key;
//     return Container(
//       decoration: const BoxDecoration(
//         color: primaryColor,
//       ),
//       child: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.only(left: 5.0, right: 5.0),
//           child: Row(
//             children: [
//               MyIconButton(Icons.menu, () => key.currentState.openDrawer()),
//               const SizedBox(width: 3.0, child: null),
//               MyIconButton(
//                   Icons.search,
//                       () => { makeArticle() }),
//               Expanded(
//                 flex: 1,
//                 child: Padding(
//                   padding: const EdgeInsets.only(
//                       top: 5.0, bottom: 10.0, left: 5.0, right: 3.0),
//                   child: TextField(
//                     controller: searchController,
//                     decoration: const InputDecoration(
//                       border: myBorder,
//                       enabledBorder: myBorder,
//                       focusedBorder: myBorder,
//                       isDense: true,
//                       hintText: "Tajpu vorton",
//                       hintStyle: TextStyle(color: Colors.white60),
//                       contentPadding:
//                       EdgeInsets.symmetric(horizontal: 3.0, vertical: 3.0),
//                     ),
//                     cursorColor: Colors.white,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 18.0,
//                     ),
//                     onChanged: (text) {
//                       print(text);
//                       makeHints();
//                     },
//                     onSubmitted: (value) {
//                       makeArticle();
//                     },
//                     autofocus: true,
//                   ),
//                 ),
//               ),
//               MyIconButton(Icons.clear, () => {searchController.clear()}),
//               MyIconButton(Icons.arrow_left, () => {}, width: 25.0),
//               MyIconButton(Icons.arrow_right, () => {}, width: 25.0),
//               MyIconButton(
//                   Icons.history, () => key.currentState.openEndDrawer()),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
// }

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

Future<Widget> getArticle(String searchtxt) async {
  String result = await getHttp(searchtxt);
  return Html(
    data: result,
    padding: EdgeInsets.all(8.0),
  );
}

Future<String> getHttp(String searchtxt) async {
  print("start request...");
  final responce = await http.get(Uri.parse(url + searchtxt));
  if (responce.statusCode == 200) {
    // вырезает необходимую часть html из сайта
    int firstMatch = responce.body.indexOf('<div class="search_result">');
    String result1 = responce.body.substring(
        firstMatch + '<div class="search_result">'.length,
        responce.body.length);
    int secondMatch = result1.indexOf('<div class="search_result">');
    String result = result1.substring(0, secondMatch);
    return result;
  } else {
    throw Exception('все фигня, перделывай');
  }}

Future<String> getHints(String searchtxt) async {
  // должен показывать подсказки к поиску
  final responce = await http.get(Uri.parse(url + '?ajax&term=' + searchtxt));
  final hintsList = jsonDecode(responce.body);

  print(hintsList);
  if (hintsList.isEmpty) {
    print('ничего не найдено');
    return responce.body;
  } else {
    print('что-то найдено: ${hintsList.length} штук');
    return responce.body;
  }
}
