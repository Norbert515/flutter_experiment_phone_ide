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
        primarySwatch: MaterialColor(4281758452, { 50: Color(0xff3672f4),100: Color(0xff3672f4),200: Color(0xff3672f4),300: Color(0xff3672f4),400: Color(0xff3672f4),500: Color(0xff3672f4),600: Color(0xff3672f4),700: Color(0xff3672f4),800: Color(0xff3672f4),900: Color(0xff3672f4),}),
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Material(
                child: Text('pressed $count times, here is a random number: ${28.0}', style: TextStyle(fontSize: 38.0),),
              ),
              Container(
                width: 83.0,
                height: 50,
                color: Theme.of(context).primaryColor,
              ),
            ]..addAll(Iterable.generate(5.0.round()).map((it) => Container(
              margin: EdgeInsets.all(4),
              height: 13.0,
              width: 44.0,
              color: Theme.of(context).primaryColor,
            )).toList()),
          ),
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            backgroundColor: Color(0xff2b5f33),
            onPressed: () {
              setState(() {
                count++;
              });
            }
         ));
  }
}
