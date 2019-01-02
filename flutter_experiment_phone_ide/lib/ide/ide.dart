import 'package:flutter/material.dart';
import 'package:flutter_experiment_phone_ide/ide/controllers.dart';
import 'package:flutter_experiment_phone_ide/ide/file_system.dart';
import 'package:flutter_experiment_phone_ide/ide/live-reload-controllers.dart';
import 'package:flutter_experiment_phone_ide/ide/v1.dart';
import 'package:http/http.dart' as http;

TestApi testApi = TestApi(http.Client(), rootUrl: "http://192.168.0.179:8080/");

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

  bool possibilityToLiveReload = false;

  bool isLiveReloading = false;

  ListOfIDEEntity loadedFiles;

  @override
  void initState() {
    super.initState();

    controller.addListener(() {
      TextSelection selection = controller.selection;
      if(selection.baseOffset != selection.extentOffset) {
        setState(() {
          possibilityToLiveReload = true;
        });
      } else {
        if(possibilityToLiveReload && !isLiveReloading) {
          setState(() {
            possibilityToLiveReload = false;
          });
        }
      }

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


  void onDoneLiveLoading() {
    setState(() {
      isLiveReloading = false;
      possibilityToLiveReload = false;
    });
  }

  void onStartLiveLoading() {
    setState(() {
      isLiveReloading = true;
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
                    future: loadedFiles == null? testApi.getResource(): Future.value(loadedFiles),
                    initialData: loadedFiles?? ListOfIDEEntity(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData)
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      ListOfIDEEntity data = snapshot.requireData;
                      loadedFiles = data;
                      return ListView(
                        children: data
                            .map((it) => FileEntryWidget(
                                  textColor: foreground,
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
                      child: Column(
                        children: <Widget>[
                          possibilityToLiveReload? LiveReloadBar(
                            liveReloadTextManipulator: LiveReloadTextManipulator(
                              filePath: currentPath,
                              textEditingController: controller,
                            ),
                            onDone: onDoneLiveLoading,
                            onStart: onStartLiveLoading,
                          ): SizedBox(),
                          possibilityToLiveReload? Divider(): SizedBox(),
                          Expanded(
                            child: TextField(
                              autofocus: true,
                              style: TextStyle(color: foreground),
                              decoration: InputDecoration(contentPadding: EdgeInsets.all(16)),
                              controller: controller,
                              maxLines: 9007199254740992,
                            ),
                          ),
                        ],
                      )),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}





enum LiveReloadState {
  POSSIBLE,
  WAITING,
  READY,
}
class LiveReloadBar extends StatefulWidget {

  const LiveReloadBar({Key key, this.onDone, this.onStart, this.liveReloadTextManipulator}) : super(key: key);



  final VoidCallback onDone;

  final VoidCallback onStart;

  final LiveReloadTextManipulator liveReloadTextManipulator;

  @override
  _LiveReloadBarState createState() => _LiveReloadBarState();
}

class _LiveReloadBarState extends State<LiveReloadBar> {

  LiveReloadState liveReloadState = LiveReloadState.POSSIBLE;


  LiveReloadTextManipulator liveReloadTextManipulator;

  @override
  void initState() {
    super.initState();
    liveReloadTextManipulator = widget.liveReloadTextManipulator;
  }

  Future initLiveReload(ReloadType reloadType) async {
    widget.onStart();
    await liveReloadTextManipulator.init(reloadType);

    setState(() {
      liveReloadState = LiveReloadState.READY;
    });
  }


  void onCancel() async {
    await liveReloadTextManipulator.cancelChanges();
    widget.onDone();

  }

  void onApply() async {
    // TODO to string wont work on everything
    await liveReloadTextManipulator.applyCode($DEFAULT_CONTROLLER$.toString());
    widget.onDone();

  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    switch(liveReloadState) {
      case LiveReloadState.POSSIBLE:
        child = _buildPossible();
        break;
      case LiveReloadState.WAITING:
        child = _buildWaiting();
        break;
      case LiveReloadState.READY:
        child = _buildReady();
        break;
    }
    return SizedBox(
      height: 52,
      child: child,
    );
  }

  /// This is being edited by the code gen
  /// Change is dynamic on purpose
  void changeValue(change) {
    $DEFAULT_CONTROLLER$ = change;
     liveReloadTextManipulator.applyVisualCode(change.toString());
     WidgetsBinding.instance.performReassemble();

  }
  Widget _getLiveController() {
    // TODO codegen must replace this name
    return LiveSliderController(
      value: $DEFAULT_CONTROLLER$,
      onChanged: changeValue,
    );
  }
  /// This is being edited by the code gen


  Widget _buildReady() {
    return Row(
      children: <Widget>[
        FlatButton(
          onPressed: onCancel,
          child: Text("Cancle", style: TextStyle(color: Colors.white)),
        ),
        Expanded(child: _getLiveController()),
        FlatButton(
          onPressed: onApply,
          child: Text("Apply", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Widget _buildWaiting() {
    return Center(child: CircularProgressIndicator(),);
  }
  Widget _buildPossible() {
    return Row(
      children: <Widget>[
        Spacer(),
        FlatButton(
          onPressed: () => initLiveReload(ReloadType.COLOR),
          child: Text("Live-Reload-Color", style: TextStyle(color: Colors.white),),
        ),
        FlatButton(
          onPressed: () => initLiveReload(ReloadType.DOUBLE),
          child: Text("Live-Reload-Double", style: TextStyle(color: Colors.white),),
        ),
      ],
    );
  }
}


enum ReloadType {
  DOUBLE,
  COLOR,
}

// Double
class LiveReloadTextManipulator {

  LiveReloadTextManipulator({this.textEditingController, this.filePath}): originalText = textEditingController.text;

  final TextEditingController textEditingController;

  final String filePath;

  final String originalText;
  TextSelection get textSelection => textEditingController.selection;

  String editedCode;
  String placeHolder;

  String originalValue;

  Future init(ReloadType reloadType) async {

    placeHolder ='\$DEFAULT_CONTROLLER\$';

    // Add actual controller
    String doubleValue = originalText.substring(textSelection.baseOffset, textSelection.extentOffset);
    String controllerCode = 'double $placeHolder = $doubleValue;';


    $DEFAULT_CONTROLLER$ = double.tryParse(originalValue);


    originalValue = originalText.substring(textSelection.baseOffset, textSelection.extentOffset);
    String withReplacement = originalText.replaceRange(textSelection.baseOffset, textSelection.extentOffset, placeHolder);

    // Add import to controllers in target file
    // This only works if the import is not present yet
    String withImport = 'import "stuff"\n $withReplacement;';


    editedCode = withReplacement;
    pushChanged();
  }



  String applyVisualCode(String value) {
    String applied = editedCode.replaceRange(textSelection.baseOffset, textSelection.baseOffset + placeHolder.length, value);
    updateCode(applied);
    return applied;
  }


  Future applyCode(String value) async {
    editedCode = applyVisualCode(value);
    await pushChanged();
  }

  Future cancelChanges() async {
    String revertedCode = editedCode.replaceRange(textSelection.baseOffset, textSelection.baseOffset + placeHolder.length, originalValue);
    editedCode = revertedCode;
    updateCode(editedCode);
    await pushChanged();
  }


  void updateCode(String newText) {
    textEditingController.value = textEditingController.value.copyWith(text: newText,
        selection: TextSelection.collapsed(offset: textEditingController.selection.baseOffset),
        composing: TextRange.empty);
  }


  Future pushChanged() async {
    await testApi.writeFile(WriteFileRequest()
      ..path = filePath
      ..newContent = editedCode
    );
    await testApi.hotReload();
  }


}


