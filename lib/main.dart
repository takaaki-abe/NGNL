import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';
import 'dart:convert';
import 'package:web_vuw/web_vuw.dart';
import 'package:flutter/foundation.dart';

Map<String, dynamic> gM;

Future<Map<String, dynamic>> rule() async {
  return json.decode(await rootBundle.loadString('assets/r.json'));
}

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    rootBundle.loadString('assets/index.html').then((g) {
      rule().then((r) {
        gM = r;
        gM["index"] = g;
        runApp(NGNL());
      });
    });
  });
}

class NGNL extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: GP(title: gM["a"]),
    );
  }
}

class GP extends StatefulWidget {
  GP({Key k, this.title}) : super(key: k);
  String title;
  @override
  _GPS createState() => _GPS();
}

class _GPS extends State<GP> {
  final _c = Completer<WebVuwController>();
  final _scKey = GlobalKey<ScaffoldState>();
  StreamSubscription _sWVE;

  @override
  void dispose() {
    if (_sWVE != null) _sWVE.cancel();
    super.dispose();
  }

  Widget _buttonArea() {
    var buttonMapLines = gM["TENKEY"];
    var style = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.normal,
      fontFamily: 'ARCADECLASSIC',
      letterSpacing: 0.5,
      fontSize: 30.0,
    );

    var rows = List<dynamic>();
    for (var lines in buttonMapLines) {
      var btns = List<Widget>();
      for (var line in lines) {
        var btn = RaisedButton(
          shape: RoundedRectangleBorder(),
          padding: EdgeInsets.symmetric(horizontal: 0.0),
          color: Colors.lightBlue,
          child: Text(line['label'], style: style),
          onPressed: () async {
            final controller = await _c.future;
            await controller.evaluateJavascript(
                'window.dispatchEvent(new KeyboardEvent("keydown", {key: "${line['code']}"}));');
          },
        );
        btns.add(btn);
      }
      rows.add(btns);
    }

    var columns = List<Widget>();
    for (var row in rows) {
      var c = Container(
          margin: const EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 0.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: row,
          ));
      columns.add(c);
    }
    var col =
        Column(mainAxisAlignment: MainAxisAlignment.start, children: columns);

    return Container(
        margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0), child: col);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebVuwController>(
      future: _c.future,
      builder:
          (BuildContext context, AsyncSnapshot<WebVuwController> snapshot) {
        final r = snapshot.connectionState == ConnectionState.done;
        final c = snapshot.data;
        if (r) {
          _sWVE = snapshot.data.onEvents().listen((events) {});
        }

        return Scaffold(
          key: _scKey,
          appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.red,
              title: Text(gM["a"]),
              actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.favorite),
                    onPressed: () async {
                      rootBundle
                          .loadString('assets/thanks.html')
                          .then((thanks) {
                        rule().then((r) {
                          c.loadHtml(thanks);
                        });
                      });
                    }),
                IconButton(
                    icon: Icon(Icons.gamepad),
                    onPressed: () async {
                      rootBundle.loadString('assets/index.html').then((g) {
                        rule().then((r) {
                          gM = r;
                          c.loadHtml(g);
                        });
                      });
                    })
              ]),
          body: Material(
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: WebVuw(
                      html: gM["index"],
                      enableJavascript: true,
                      pullToRefresh: false,
                      javaScriptMode: JavaScriptMode.unrestricted,
                      onWebViewCreated: (WebVuwController webViewController) {
                        _c.complete(webViewController);
                      },
                    ),
                  ),
                  _buttonArea(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
