import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart' show debugDefaultTargetPlatformOverride;
import 'package:flutter_experiment_phone_ide/ide/controllers.dart';
import 'package:flutter_experiment_phone_ide/ide/ide.dart';

void main() {
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch:     MaterialColor(0xff00ffff, {
          50: Color(0xff00ffff),
          100: Color(0xff00ffff),
          200: Color(0xff00ffff),
          300: Color(0xff00ffff),
          400: Color(0xff00ffff),
          500: Color(0xff00ffff),
          600: Color(0xff00ffff),
          700: Color(0xff00ffff),
          800: Color(0xff00ffff),
          900: Color(0xff00ffff),
        }),
      ),
      home: IdeApp(child: new MyHomePage()),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Flutter Demo Home Page'),
        ),
        body: new Center(
          child: Container(
            child: Material(
              child: Text('pressed $count times, here is a random number: ${28.0}', style: TextStyle(fontSize: 23.0),),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            backgroundColor: $DEFAULT_CONTROLLER$,
            onPressed: () {
              setState(() {
                count++;
              });
            }
         ));
  }
}
