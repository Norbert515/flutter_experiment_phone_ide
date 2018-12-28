import 'package:rpc/rpc.dart';

import 'file_server.dart';
import 'flutter_runner.dart';
import 'models.dart';
import 'package:path/path.dart' as path;

@ApiClass(version: 'v1', name: "test")
class API {

  API(this.projectDir, String deviceId):
    fileServer = FileServer(path.join(projectDir, "lib")),
    flutterRunner = FlutterRunner(projectDir, deviceId);

  final FileServer fileServer;

  final FlutterRunner flutterRunner;

  final String projectDir;

  @ApiMethod(method: 'GET', path: 'listFiles')
  List<IDEEntity> getResource() {
    return fileServer.getAllFiles();
  }

  @ApiMethod(method: 'GET', path: 'readFile')
  StringMessage updateResource({String path}) {
    return StringMessage(value: fileServer.openFile(path));
  }

  @ApiMethod(method: 'POST', path: 'writeFile')
  VoidMessage writeFile(WriteFileRequest request) {
    fileServer.replaceFile(request.path, request.newContent);
    return VoidMessage();
  }

  @ApiMethod(method: 'GET', path: 'coldStart')
  VoidMessage coldStart() {
    flutterRunner.coldStart();
    return VoidMessage();
  }

  @ApiMethod(method: 'GET', path: 'hotRestart')
  VoidMessage hotRestart() {
    flutterRunner.hotRestart();
    return VoidMessage();
  }

  @ApiMethod(method: 'GET', path: 'hotReload')
  VoidMessage hotReload() {
    flutterRunner.hotReload();
    return VoidMessage();
  }
}

class WriteFileRequest {

  String path;
  String newContent;

}
class StringMessage {

  StringMessage({this.value});

  final String value;
}