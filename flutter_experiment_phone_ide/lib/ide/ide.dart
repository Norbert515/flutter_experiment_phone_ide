import 'package:flutter/material.dart';
import 'package:flutter_experiment_phone_ide/ide/v1.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:quill_delta/quill_delta.dart';
import 'package:zefyr/zefyr.dart';

TestApi testApi = TestApi(http.Client(), rootUrl: "http://192.168.0.178:8080/");

const Color foreground = Color(0xffA9B7C6);
const Color background = Color(0xff2B2B2B);

class IdeApp extends StatefulWidget {
  const IdeApp({Key key, this.child}) : super(key: key);

  final Widget child;

  @override
  _IdeAppState createState() => new _IdeAppState();
}

class _IdeAppState extends State<IdeApp> {
  TextEditingController controller = TextEditingController(text: "");

  String currentPath;

  bool keyboardShowing = false;


  @override
  void initState() {
    super.initState();

    controller.addListener(() {
     // controller.value.selection
    });

  }

  void onFileSelected(String fileName) async {
    // Close drawer
    Navigator.pop(context);
    StringMessage message = await testApi.updateResource(path: fileName);
    setState(() {
      currentPath = fileName;
      controller.text = message.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: SafeArea(
          child: Material(
            color: background,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: <Widget>[
                      Text(
                        "IDE enabled",
                        style: TextStyle(color: foreground),
                      ),
                      Switch(
                          value: keyboardShowing,
                          onChanged: (it) {
                            setState(() {
                              keyboardShowing = it;
                            });
                          }),
                    ],
                  ),
                ),
                Expanded(
                  child: FutureBuilder<ListOfIDEEntity>(
                    future: testApi.getResource(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData)
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      ListOfIDEEntity data = snapshot.requireData;
                      return ListView(
                        children: data
                            .map((it) => FileEntryWidget(
                                  ideEntity: it,
                                  onFileSelected: onFileSelected,
                                  selectedFile: currentPath,
                                ))
                            .toList(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          keyboardShowing
              ? FloatingActionButton(
                  child: Icon(Icons.refresh),
                  onPressed: () async {
                    await testApi.writeFile(WriteFileRequest()
                      ..path = currentPath
                      ..newContent = controller.text);
                    testApi.hotReload();
                  },
                )
              : SizedBox(),
          SizedBox(
            width: 8,
          ),
          keyboardShowing
              ? FloatingActionButton(
                  child: Icon(Icons.play_arrow),
                  onPressed: () async {
                    await testApi.writeFile(WriteFileRequest()
                      ..path = currentPath
                      ..newContent = controller.text);
                    testApi.hotRestart();
                  },
                )
              : SizedBox(),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(child: widget.child),
          keyboardShowing
              ? Expanded(
                  child: Material(
                      color: background,
                      child: TextField(
                        style: TextStyle(color: foreground),
                        decoration: InputDecoration(contentPadding: EdgeInsets.all(16)),
                        controller: controller,
                        maxLines: 9007199254740992,
                      )),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}

typedef OnFileSelected = Function(String name);

class FileEntryWidget extends StatelessWidget {
  const FileEntryWidget({Key key, this.ideEntity, this.onFileSelected, this.selectedFile}) : super(key: key);

  final IDEEntity ideEntity;

  final OnFileSelected onFileSelected;

  final String selectedFile;

  @override
  Widget build(BuildContext context) {
    if (ideEntity.isFile) {
      return InkWell(
        onTap: () {
          onFileSelected(ideEntity.name);
        },
        child: Container(
          color: selectedFile == ideEntity.name ? Color(0xff2b62cd) : Colors.transparent,
          padding: EdgeInsets.all(8),
          height: 30,
          child: SizedBox.expand(
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    path.basename(ideEntity.name),
                    style: TextStyle(color: foreground),
                  ))),
        ),
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(8),
            height: 50.0,
            child:
                SizedBox.expand(child: Align(alignment: Alignment.centerLeft, child: Text(path.basename(ideEntity.name), style: TextStyle(color: foreground)))),
          ),
        ]..addAll(ideEntity.files
            .map((it) => Padding(
                  padding: EdgeInsets.only(left: 24.0),
                  child: FileEntryWidget(
                    ideEntity: it,
                    onFileSelected: onFileSelected,
                    selectedFile: selectedFile,
                  ),
                ))
            .toList()),
      );
    }
  }
}
