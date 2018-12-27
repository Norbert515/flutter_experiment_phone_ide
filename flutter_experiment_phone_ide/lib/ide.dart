import 'package:flutter/material.dart';

class IdeApp extends StatefulWidget {
  const IdeApp({Key key, this.child}) : super(key: key);

  final Widget child;

  @override
  _IdeAppState createState() => new _IdeAppState();
}

class _IdeAppState extends State<IdeApp> {

  TextEditingController controller = TextEditingController(
    text: "import 'package:flutter/material.dart';\r\n\r\nimport 'package:flutter/foundation.dart'\r\n    show debugDefaultTargetPlatformOverride;\r\nimport 'package:flutter_experiment_phone_ide/ide.dart';\r\nvoid main() {\r\n  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;\r\n  runApp(new MyApp());\r\n}\r\n\r\nclass MyApp extends StatelessWidget {\r\n  @override\r\n  Widget build(BuildContext context) {\r\n    return new MaterialApp(\r\n      title: 'Flutter Demo',\r\n      theme: new ThemeData(\r\n        primarySwatch: Colors.blue,\r\n      ),\r\n      home: IdeApp(child: new MyHomePage()),\r\n    );\r\n  }\r\n}\r\n\r\nclass MyHomePage extends StatefulWidget {\r\n  MyHomePage({Key key}) : super(key: key);\r\n\r\n  @override\r\n  _MyHomePageState createState() => new _MyHomePageState();\r\n}\r\n\r\nclass _MyHomePageState extends State<MyHomePage> {\r\n\r\n  @override\r\n  Widget build(BuildContext context) {\r\n    return new Scaffold(\r\n      appBar: new AppBar(\r\n        title: new Text('Flutter Demo Home Page'),\r\n      ),\r\n      body: new Center(\r\n       child: Container(\r\n         child: Material(\r\n           child: Text('Flutter Demo Home Page'),\r\n         ),\r\n       ),\r\n      ),\r\n    );\r\n  }\r\n}\r\n\r\n"
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FloatingActionButton(
            child: Icon(Icons.arrow_forward),
            onPressed: () {

            },
          ),
          FloatingActionButton(
            child: Icon(Icons.reply),
            onPressed: () {

            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(child: widget.child),
          Expanded(
            child: Material(
                child: TextField(
                  controller: controller,
              maxLines: TextField.noMaxLength,
            )),
          ),
        ],
      ),
    );
  }
}
