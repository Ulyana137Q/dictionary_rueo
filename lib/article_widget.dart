import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:proba1/model.dart';

class ArticleView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ArticleViewState();
  }
}

class ArticleViewState extends State<ArticleView> {

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // return StreamBuilder<String>(
    //   stream: model.articleStream.stream,
    //   initialData:  '',
    //   builder: (
    //       BuildContext context,
    //       AsyncSnapshot<String> snapshot,
    //       ) {
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return Column(
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: const [
    //           CircularProgressIndicator(),
    //         ],
    //       );
    //     } else if (snapshot.connectionState == ConnectionState.active ||
    //         snapshot.connectionState == ConnectionState.done) {
    //       if (snapshot.hasError) {
    //         return const Text('Eraro dum prenado de sugestoj!');
    //       } else if (snapshot.hasData) {
            return Center(
              child: Html(
                data: model.giveArticle(),//snapshot.data![0],
                defaultTextStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                ),
                padding: const EdgeInsets.all(8.0),
              ),
            );
    //       } else {
    //         return const Text("Ne estas artikolo!");
    //       }
    //     } else {
    //       return Text('Stato: ${snapshot.connectionState}');
    //     }
    //   },
    // );
  }

}
